#!/usr/bin/env ruby
# Builds the data behind the course map (/notes/map/): every course, every note in its
# courses, and one edge for each concept a note requires from a note that defines it.
#
#   ruby tools/graph.rb            # print a summary and the busiest course links
#   ruby tools/graph.rb --write    # write assets/data/graph.json (the map page fetches it)
#   ruby tools/graph.rb --check    # exit 1 when assets/data/graph.json is stale
#
# Re-run --write after adding notes or changing `requires` / `defines`, like backlog.rb.
# Standard library only.
require "yaml"
require "date"
require "json"

Encoding.default_external = Encoding::UTF_8
ROOT = File.expand_path("..", __dir__)
OUT = File.join(ROOT, "assets/data/graph.json")

def front_matter(path)
  raw = File.read(path)
  m = raw.match(/\A---\n(.*?)\n---\n?(.*)\z/m) or return [{}, raw]
  [YAML.safe_load(m[1], permitted_classes: [Date, Time]) || {}, m[2]]
end

def build(root)
  domains = YAML.load_file(File.join(root, "_data/domains.yml"))
  courses = Dir[File.join(root, "_data/courses/*.yml")].map { |p| YAML.load_file(p).merge("slug" => File.basename(p, ".yml")) }
  domain_order = domains.each_with_index.to_h { |d, i| [d["id"], i] }
  courses.sort_by! { |c| [domain_order[c["domain"]] || 99, c["order"] || 0, c["title"].to_s] }

  notes = {}
  Dir[File.join(root, "_notes/**/*.md")].each do |path|
    key = path.sub("#{root}/_notes/", "").sub(/\.md\z/, "")
    fm, body = front_matter(path)
    next if fm.empty?
    notes[key] = { "fm" => fm, "written" => !body.strip.empty? }
  end

  nodes = []
  index = {}
  course_rows = courses.each_with_index.map do |c, ci|
    written = 0
    total = 0
    Array(c["parts"]).each_with_index do |part, pi|
      Array(part["notes"]).each_with_index do |key, pos|
        n = notes[key] or next
        next if index.key?(key)
        index[key] = nodes.size
        total += 1
        written += 1 if n["written"]
        nodes << { "k" => key, "c" => ci, "p" => pi, "i" => pos, "t" => n["fm"]["title"].to_s, "w" => n["written"] ? 1 : 0 }
      end
    end
    d = domains.find { |x| x["id"] == c["domain"] } || {}
    { "slug" => c["slug"], "title" => c["short"] || c["title"], "full" => c["title"], "domain" => c["domain"],
      "hue" => d["hue"] || 6, "parts" => Array(c["parts"]).map { |p| p["title"].to_s }, "written" => written, "total" => total }
  end

  definer = {}
  notes.each do |key, n|
    Array(n["fm"]["defines"]).each { |d| definer[d["id"].to_s] ||= [key, d["name"].to_s] if d.is_a?(Hash) }
  end

  edges = {}
  notes.each do |key, n|
    to = index[key] or next
    Array(n["fm"]["requires"]).each do |r|
      from_key, name = definer[r.to_s]
      from = from_key && index[from_key] or next
      next if from == to
      (edges[[from, to]] ||= []) << name
    end
  end
  rows = edges.map { |(f, t), names| [f, t, names.uniq.join(", ")] }.sort
  { "courses" => course_rows, "domains" => domains.map { |d| { "id" => d["id"], "title" => d["title"], "hue" => d["hue"] } },
    "notes" => nodes, "edges" => rows }
end

if $PROGRAM_NAME == __FILE__
  data = build(ROOT)
  json = JSON.generate(data) + "\n"
  case ARGV.first
  when "--write"
    Dir.mkdir(File.dirname(OUT)) unless Dir.exist?(File.dirname(OUT))
    File.write(OUT, json)
    puts "wrote #{OUT.sub("#{ROOT}/", '')}: #{data['courses'].size} courses, #{data['notes'].size} notes, #{data['edges'].size} links"
  when "--check"
    if File.exist?(OUT) && File.read(OUT) == json
      puts "assets/data/graph.json is up to date"
    else
      warn "assets/data/graph.json is stale: run `ruby tools/graph.rb --write`"
      exit 1
    end
  else
    cn = data["notes"].map { |n| n["c"] }
    cross = Hash.new(0)
    data["edges"].each { |f, t, _| cross[[cn[f], cn[t]]] += 1 if cn[f] != cn[t] }
    puts "#{data['courses'].size} courses, #{data['notes'].size} notes, #{data['edges'].size} links (#{cross.values.sum} between courses)"
    cross.sort_by { |_, v| -v }.first(15).each do |(a, b), v|
      puts format("%4d  %s -> %s", v, data["courses"][a]["slug"], data["courses"][b]["slug"])
    end
  end
end
