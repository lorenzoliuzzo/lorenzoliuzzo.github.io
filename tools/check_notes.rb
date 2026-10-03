#!/usr/bin/env ruby
# Checks the notes that belong to a course (_data/courses.yml) against the standard in
# .claude/skills/write-site-note/. Standard library only, so CI needs no bundle install.
#
#   ruby tools/check_notes.rb            # all course notes
#   ruby tools/check_notes.rb statistics # notes whose path starts with statistics/
#
# Errors fail the run (exit 1); warnings are printed and do not. The same mistakes in
# front matter also show up as warnings in _plugins/concept_index.rb at build time.
require "yaml"
require "date"

Encoding.default_external = Encoding::UTF_8

ROOT = File.expand_path("..", __dir__)
CALLOUTS = %w[idea trap rule derive try margin spec keyed].freeze
MAX_WORDS = 1500

def front_matter(path)
  raw = File.read(path)
  m = raw.match(/\A---\n(.*?)\n---\n?(.*)\z/m) or return [{}, raw]
  [YAML.safe_load(m[1], permitted_classes: [Date, Time]) || {}, m[2]]
end

# Same ids kramdown gives headings: drop leading non-letters, strip punctuation, hyphenate.
def heading_ids(body)
  seen = Hash.new(0)
  body.scan(/^\#{1,6} (.+)$/).flatten.map do |text|
    id = text.gsub(/^[^a-zA-Z]+/, "").gsub(/[^a-zA-Z0-9 -]/, "").tr(" ", "-").downcase
    id = "section" if id.empty?
    seen[id] += 1
    seen[id] > 1 ? "#{id}-#{seen[id] - 1}" : id
  end
end

courses = YAML.load_file(File.join(ROOT, "_data/courses.yml"))
filter = ARGV[0]

notes = {} # key => {path:, data:, body:}
Dir[File.join(ROOT, "_notes/**/*.md")].sort.each do |path|
  key = path.sub("#{ROOT}/_notes/", "").sub(/\.md\z/, "")
  data, body = front_matter(path)
  notes[key] = { path: path.sub("#{ROOT}/", ""), data: data, body: body, written: !body.strip.empty? }
end

order = {} # note key => [course index, position]
courses.each_with_index do |course, ci|
  pos = 0
  course["parts"].each { |part| part["notes"].each { |k| order[k] ||= [ci, pos += 1] } }
end

concepts = {} # id => note key
notes.each do |key, n|
  Array(n[:data]["defines"]).each do |c|
    id = c.is_a?(Hash) ? c["id"].to_s : next
    if concepts.key?(id)
      puts "ERROR #{n[:path]}: concept #{id} is also defined in #{concepts[id]}"
      $failed = true
    end
    concepts[id] = key
  end
end

errors = 0
warnings = 0
err = ->(n, msg) { puts "ERROR #{n[:path]}: #{msg}"; errors += 1 }
warn_ = ->(n, msg) { puts "warn  #{n[:path]}: #{msg}"; warnings += 1 }

courses.each do |course|
  course["parts"].each do |part|
    part["notes"].each do |key|
      next if filter && !key.start_with?(filter)

      n = notes[key]
      if n.nil?
        puts "ERROR _data/courses.yml lists #{key}, but _notes/#{key}.md does not exist"
        errors += 1
        next
      end
      next unless n[:written]

      d, body = n[:data], n[:body]

      %w[title date excerpt hook goals tags].each { |k| err.(n, "front matter lacks `#{k}`") if d[k].nil? || d[k].to_s.strip.empty? }
      goals = Array(d["goals"])
      err.(n, "`goals` should have 2 to 4 items, has #{goals.size}") unless (2..4).cover?(goals.size)
      err.(n, "`hook` should be one sentence, under 45 words") if d["hook"].to_s.split.size > 45
      err.(n, "set neither `layout` nor `permalink`; the collection defaults apply") if d["layout"] || d["permalink"]
      defines = Array(d["defines"])
      err.(n, "`defines` is empty: a note must introduce at least one concept") if defines.empty?

      ids = heading_ids(body)
      defines.each do |c|
        err.(n, "`defines` entry needs id, name and anchor: #{c.inspect}") unless c.is_a?(Hash) && c["id"] && c["name"] && c["anchor"]
        next unless c.is_a?(Hash) && c["anchor"]

        err.(n, "concept #{c['id']}: no heading with id `#{c['anchor']}`") unless ids.include?(c["anchor"])
        err.(n, "concept id `#{c['id']}` should be lower-case and hyphenated") unless c["id"].to_s.match?(/\A[a-z0-9]+(-[a-z0-9]+)*\z/)
      end

      Array(d["requires"]).each do |r|
        id = r.is_a?(Hash) ? r["concept"].to_s : r.to_s
        owner = concepts[id]
        if owner.nil?
          err.(n, "requires unknown concept `#{id}`")
        elsif owner == key
          err.(n, "requires `#{id}`, which it defines itself")
        elsif order[owner] && order[key] && order[owner][0] == order[key][0] && order[owner][1] > order[key][1]
          err.(n, "requires `#{id}`, which #{owner} introduces later in the course")
        end
      end
      err.(n, "`requires` lists more than 8 concepts; a note should lean on few earlier ideas") if Array(d["requires"]).size > 8

      intro = body.split(/^\#{1,6} /, 2).first.to_s.strip
      err.(n, "no introduction before the first heading") if intro.empty?
      warn_.(n, "introduction is #{intro.split.size} words; aim for one or two sentences") if intro.split.size > 75
      if course["reference"] && !intro.include?(File.basename(course["reference"]))
        warn_.(n, "introduction does not link the course reference PDF")
      end

      words = body.split.size
      warn_.(n, "#{words} words; a site note should stay under #{MAX_WORDS}, move detail to the reference") if words > MAX_WORDS
      err.(n, "body has an em dash; rewrite the sentence") if body.include?("—")
      err.(n, "the first heading should not be `Before you start`; prerequisites come from `requires`") if body.match?(/^\# Before you start/)

      # Recap
      if body =~ /^\# Recap$/
        qa = body.scan(/<details class="qa" markdown="1">/).size
        err.(n, "`# Recap` needs at least 2 recall cards (<details class=\"qa\">), has #{qa}") if qa < 2
      else
        err.(n, "no `# Recap` section")
      end

      # Callouts: known classes, at most one .idea per level-1 section.
      body.scan(/^\{: ([^}]+)\}$/).flatten.each do |attrs|
        attrs.split.each do |tok|
          cls = tok.sub(/\A\./, "")
          warn_.(n, "unknown class `#{tok}` in #{attrs}") unless tok.start_with?(".") && CALLOUTS.include?(cls)
        end
      end
      body.split(/^\# /).drop(1).each do |sec|
        count = sec.scan(/^\{: \.idea\}$/).size
        err.(n, "section `#{sec.lines.first.strip}` has #{count} .idea callouts; use at most one") if count > 1
      end

      # Figures
      body.scan(/\{% include fig\.html (.*?) %\}/m).flatten.each do |args|
        src = args[/src="([^"]+)"/, 1]
        err.(n, "figure without src") && next unless src
        err.(n, "figure #{src}: missing _includes/fig/#{src}.svg (run tools/figures/build.py)") unless File.exist?(File.join(ROOT, "_includes/fig/#{src}.svg"))
        err.(n, "figure #{src}: no alt text") unless args =~ /alt="[^"]{12,}"/
        err.(n, "figure #{src}: no caption") unless args =~ /caption="[^"]{12,}"/
      end

      # Links to other notes: the note must exist and the anchor must be one of its headings.
      body.scan(%r{/notes/([a-z0-9/-]+?)/' \| relative_url \}\}(?:#([a-z0-9-]+))?}).each do |target, anchor|
        t = notes[target]
        if t.nil?
          err.(n, "links to /notes/#{target}/, which does not exist")
        elsif anchor && t[:written] && !heading_ids(t[:body]).include?(anchor)
          err.(n, "link to #{target}##{anchor}: no such heading")
        end
      end

      # Tables: every row must have as many cells as the header (an unescaped | in math splits a cell).
      block = []
      (body.lines + [""]).each do |line|
        if line.start_with?("|")
          block << line
        elsif !block.empty?
          cols = block.first.scan(/(?<!\\)\|/).size
          block.each_with_index do |row, i|
            next if row.scan(/(?<!\\)\|/).size == cols

            err.(n, "table row #{i + 1} has a different number of cells than its header (use \\mid inside math): #{row.strip[0, 60]}")
          end
          block = []
        end
      end
    end
  end
end

puts "#{errors} error(s), #{warnings} warning(s)"
exit(errors.zero? ? 0 : 1)
