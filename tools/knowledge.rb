#!/usr/bin/env ruby
# The curator's view of typed knowledge: which concepts have a definition, a result and an
# example, and where the gaps are. Uses the same model as the site (_plugins/knowledge.rb).
#
#   ruby tools/knowledge.rb                    # one line per course
#   ruby tools/knowledge.rb <course>           # every concept of a course and what it lacks
#   ruby tools/knowledge.rb --slots [course]   # the six-slot score (define, claim, justify, instance, boundary, practice) per concept
#   ruby tools/knowledge.rb --gaps [N]         # the N concepts (default 25) most worth fixing, by how many notes use them
#   ruby tools/knowledge.rb --suggest <course|note-path>
#                                              # draft .definition blocks from the bold terms already in the text
#   ruby tools/knowledge.rb --apply <course|note-path>
#                                              # make the clean ones: a paragraph that is exactly the defining
#                                              # sentence becomes the .definition block, and the concept's anchor
#                                              # points at it. Everything else is left for you. Review with git diff.
#
# --suggest only prints; paste what you agree with into the note by hand and set the
# concept's `anchor` to the block id. Standard library only.
require "yaml"
require "date"
require "json"

Encoding.default_external = Encoding::UTF_8
ROOT = File.expand_path("..", __dir__)
require File.join(ROOT, "_plugins/knowledge.rb")
K = MyThingsLab::Knowledge

def front_matter(path)
  raw = File.read(path)
  m = raw.match(/\A---\n(.*?)\n---\n?(.*)\z/m) or return [{}, raw]
  [YAML.safe_load(m[1], permitted_classes: [Date, Time]) || {}, m[2]]
end

spec = YAML.load_file(File.join(ROOT, "_data/knowledge.yml"))
kinds = spec["kinds"].to_h { |k| [k["id"], k] }
courses = Dir[File.join(ROOT, "_data/courses/*.yml")].sort.map { |p| YAML.load_file(p).merge("slug" => File.basename(p, ".yml")) }
course_of = {}
courses.each { |c| Array(c["parts"]).each { |pt| Array(pt["notes"]).each { |n| course_of[n] = c["slug"] } } }

notes = []
concepts = {}
bodies = {}
Dir[File.join(ROOT, "_notes/**/*.md")].sort.each do |path|
  key = path.sub("#{ROOT}/_notes/", "").sub(/\.md\z/, "")
  fm, body = front_matter(path)
  next if fm.empty?
  written = !body.strip.empty?
  Array(fm["defines"]).each do |d|
    next unless d.is_a?(Hash) && d["id"]
    concepts[d["id"].to_s] ||= { "id" => d["id"].to_s, "name" => d["name"].to_s, "note" => key, "title" => fm["title"].to_s,
                                 "url" => "/notes/#{key}/", "anchor" => d["anchor"].to_s, "planned" => !written }
  end
  next unless written
  _, found = K.scan(body, kinds, key)
  bodies[key] = body
  notes << { "key" => key, "title" => fm["title"].to_s, "url" => "/notes/#{key}/", "course" => course_of[key],
             "defines" => Array(fm["defines"]).select { |d| d.is_a?(Hash) }, "requires" => Array(fm["requires"]), "blocks" => found }
end
used = Hash.new(0)
notes.each { |n| n["requires"].each { |r| used[r.is_a?(Hash) ? r["concept"].to_s : r.to_s] += 1 } }
sheets = K.model(notes, kinds, concepts)["concepts"]
written = sheets.values.reject { |c| c["planned"] }
by_course = written.group_by { |c| course_of[c["note"]] || "(no course)" }

def pct(n, d) = d.zero? ? "  -" : format("%3d%%", (n * 100.0 / d).round)

arg = ARGV.first
case arg
when "--gaps"
  n = (ARGV[1] || 25).to_i
  rows = written.select { |c| c["gaps"].include?("definition") }.sort_by { |c| [-used[c["id"]], c["name"]] }.first(n)
  puts "Concepts without a .definition block, most used first:"
  rows.each { |c| puts format("%3d notes use  %-34s %s", used[c["id"]], c["name"], c["note"]) }
when "--slots"
  target = ARGV[1]
  rows = written.select { |c| target.nil? || course_of[c["note"]] == target }
  names = MyThingsLab::Knowledge::SLOTS
  if target
    puts format("%-34s %s  score", "concept", names.map { |n| n[0, 4] }.join(" "))
    rows.sort_by { |c| [c["score"], c["name"]] }.each do |c|
      puts format("%-34s %s  %d/6", c["name"][0, 34], names.map { |n| c["slots"][n] ? " ## " : "  . " }.join(""), c["score"])
    end
  else
    puts format("%-32s %8s %s  mean", "course", "concepts", names.map { |n| n[0, 4].rjust(5) }.join(""))
    by_course.sort.each do |slug, cs|
      puts format("%-32s %8d %s  %.1f", slug, cs.size, names.map { |n| pct(cs.count { |c| c["slots"][n] }, cs.size).rjust(5) }.join(""), cs.sum { |c| c["score"] } / cs.size.to_f)
    end
    puts format("%-32s %8d %s  %.1f", "all", written.size, names.map { |n| pct(written.count { |c| c["slots"][n] }, written.size).rjust(5) }.join(""), written.sum { |c| c["score"] } / written.size.to_f)
  end
when "--apply"
  target = ARGV[1] or abort "usage: --apply <course|note-path>"
  keys = notes.select { |n| n["course"] == target || n["key"] == target || n["key"].start_with?(target) }.map { |n| n["key"] }
  abort "no written note matches #{target}" if keys.empty?
  changed = 0
  keys.each do |key|
    path = File.join(ROOT, "_notes", "#{key}.md")
    raw = File.read(path)
    head, body = raw.match(/\A(---\n.*?\n---\n?)(.*)\z/m).captures
    todo = written.select { |c| c["note"] == key && c["gaps"].include?("definition") }
    done = []
    todo.each do |c|
      term = Regexp.escape(c["name"].sub(/'s\z/, ""))
      # the first sentence that carries the bold term, in a plain paragraph (not a list, table, heading or tag)
      para = body.split(/\n{2,}/).find { |p| p =~ /\*\*#{term}\*\*/i && p !~ /\A(\#|\||\{%|<|>|[-*]\s|\d+\.\s|\{:)/ }
      next unless para
      parts = para.split(/(?<=[.!?])(\s+)(?=[A-Z$*])/) # sentences at even positions, separators at odd
      sents = parts.each_slice(2).map(&:first)
      seps = parts.each_slice(2).map { |_, sp| sp }
      hit = sents.index { |x| x =~ /\*\*#{term}\*\*/i } or next
      next if sents[hit].count("$").odd? || sents[hit] =~ /(following|below|:)\.?\z/ # definition continues in the next sentences: leave it by hand
      id = "def-#{c['id']}"
      title = c["name"][0].upcase + c["name"][1..]
      join = ->(range) { range.map { |i| sents[i] + (seps[i] || "") }.join.strip }
      before = join.call(0...hit)
      after = join.call((hit + 1)...sents.size)
      block = "> #{sents[hit].gsub(/\s*\n\s*/, ' ')}\n{: .definition ##{id} title=\"#{title}\"}"
      body = body.sub(para) { [before, block, after].reject(&:empty?).join("\n\n") }
      # point the concept's anchor at the block
      cid = Regexp.escape(c["id"])
      head2 = head.sub(/(- id: #{cid}\n(?:\s+name:[^\n]*\n)?\s+anchor: )[^\n]+/, "\\1#{id}")
      head2 = head.sub(/(\{id: #{cid},[^}]*?anchor: )[^,}]+/, "\\1#{id}") if head2 == head
      next if head2 == head
      head = head2
      done << c["name"]
    end
    next if done.empty?
    File.write(path, head + body)
    changed += done.size
    puts "#{key}: #{done.join(', ')}"
  end
  puts "\n#{changed} definitions made. Run ruby tools/check_notes.rb and look at git diff."
when "--suggest"
  target = ARGV[1] or abort "usage: --suggest <course|note-path>"
  keys = notes.select { |n| n["course"] == target || n["key"] == target || n["key"].start_with?(target) }.map { |n| n["key"] }
  abort "no written note matches #{target}" if keys.empty?
  keys.each do |key|
    todo = written.select { |c| c["note"] == key && c["gaps"].include?("definition") }
    next if todo.empty?
    puts "\n== #{key}"
    paras = bodies[key].split(/\n{2,}/)
    todo.each do |c|
      term = Regexp.escape(c["name"].sub(/'s\z/, ""))
      para = paras.find { |p| p =~ /\*\*#{term}\*\*/i && p !~ /\A(\#|\||\{%|<|>)/ }
      sentence = para && para.gsub(/\s*\n\s*/, " ").split(/(?<=[.!?])\s+(?=[A-Z$*])/).find { |s| s =~ /\*\*#{term}\*\*/i }
      puts "\n# #{c['name']}  (#{c['id']}, anchor now: #{c['anchor']})"
      if sentence
        puts "> #{sentence}"
        puts "{: .definition #def-#{c['id']} title=\"#{c['name'][0].upcase}#{c['name'][1..]}\"}"
      else
        puts "(no bold occurrence of the term; write the definition by hand)"
      end
    end
  end
when nil
  puts format("%-32s %8s %8s %8s %8s", "course", "concepts", "defined", "results", "example")
  by_course.sort.each do |slug, cs|
    puts format("%-32s %8d %8s %8s %8s", slug, cs.size, pct(cs.count { |c| c["definition"] }, cs.size),
                pct(cs.count { |c| c["results"].any? }, cs.size), pct(cs.count { |c| c["use"].any? }, cs.size))
  end
  puts format("%-32s %8d %8s %8s %8s", "all", written.size, pct(written.count { |c| c["definition"] }, written.size),
              pct(written.count { |c| c["results"].any? }, written.size), pct(written.count { |c| c["use"].any? }, written.size))
  loose = sheets.values.flat_map { |c| c["results"] + c["use"] }.size
  puts "\n#{notes.sum { |n| n['blocks'].size }} typed blocks in #{notes.size} written notes."
else
  cs = by_course[arg] or abort "unknown course #{arg}"
  cs.each do |c|
    marks = %w[definition result example].map { |g| c["gaps"].include?(g) ? "-" : "x" }.join
    puts format("%-4s %-36s used by %2d  %s", marks, c["name"], used[c["id"]], c["note"].split("/").last)
  end
  puts "\ncolumns: definition, result, example   (x present, - missing)"
end
