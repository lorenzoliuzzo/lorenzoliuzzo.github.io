#!/usr/bin/env ruby
# Checks the courses (_data/courses/<slug>.yml, grouped by _data/domains.yml) and the notes
# that belong to them against the standard in .claude/skills/write-site-note/. Standard
# library only, so CI needs no bundle install.
#
#   ruby tools/check_notes.rb            # all courses and their notes
#   ruby tools/check_notes.rb statistics # notes whose path starts with statistics/
#
# A course marked `legacy: true` (notes imported before the standard existed) gets the
# structural checks only: its files exist, every note is listed once, its domain is known.
# Drop the flag when its notes have been brought up to standard and the full checks start.
#
# Front matter may also carry `cites` (paper ids from _data/papers.yml) and `relates`
# (project ids, the file names in _projects/); unknown ids are errors. So is an unknown id in a
# {% cite %} or {% citet %} tag in the text (see _plugins/citations.rb). A note that follows the
# standard and cites nothing gets a warning, and so does a paper that no note cites.
#
# Errors fail the run (exit 1); warnings are printed and do not. The same mistakes in
# front matter also show up as warnings in _plugins/concept_index.rb at build time.
require "yaml"
require "date"

Encoding.default_external = Encoding::UTF_8

ROOT = File.expand_path("..", __dir__)
KNOWLEDGE = YAML.load_file(File.join(ROOT, "_data/knowledge.yml"))
# Classes that are not a kind of knowledge, plus every kind in _data/knowledge.yml.
CALLOUTS = (%w[margin spec keyed booktabs] + KNOWLEDGE["kinds"].map { |k| k["id"] }).freeze
MAX_WORDS = 1500

def front_matter(path)
  raw = File.read(path)
  m = raw.match(/\A---\n(.*?)\n---\n?(.*)\z/m) or return [{}, raw]
  [YAML.safe_load(m[1], permitted_classes: [Date, Time]) || {}, m[2]]
end

# Same ids kramdown gives headings: drop leading non-letters, strip punctuation, hyphenate.
def heading_ids(body)
  seen = Hash.new(0)
  prose = body.gsub(/^(`{3,}|~{3,}).*?^\1[ \t]*$/m, "") # a `# comment` in a code block is not a heading
  prose.scan(/^\#{1,6} (.+)$/).flatten.map do |text|
    id = text.gsub(/^[^a-zA-Z]+/, "").gsub(/[^a-zA-Z0-9 -]/, "").tr(" ", "-").downcase
    id = "section" if id.empty?
    seen[id] += 1
    seen[id] > 1 ? "#{id}-#{seen[id] - 1}" : id
  end
end

domains = YAML.load_file(File.join(ROOT, "_data/domains.yml")).map { |d| d["id"] }

# The research layer: `cites` in a note names papers in _data/papers.yml, `relates` names
# projects (the file names in _projects/, without .md).
papers_path = File.join(ROOT, "_data/papers.yml")
papers = File.exist?(papers_path) ? Array(YAML.load_file(papers_path)) : []
paper_ids = papers.map { |p| p.is_a?(Hash) ? p["id"].to_s : "" }
project_ids = Dir[File.join(ROOT, "_projects/*.md")].map { |f| File.basename(f, ".md") }
courses = Dir[File.join(ROOT, "_data/courses/*.yml")].sort.map do |path|
  YAML.load_file(path).merge("slug" => File.basename(path, ".yml"), "file" => path.sub("#{ROOT}/", ""))
end
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
  Array(course["parts"]).each { |part| Array(part["notes"]).each { |k| order[k] ||= [ci, pos += 1] } }
end

concepts = {} # id => note key
duplicate_ids = 0
notes.each do |key, n|
  Array(n[:data]["defines"]).each do |c|
    id = c.is_a?(Hash) ? c["id"].to_s : next
    if concepts.key?(id)
      puts "ERROR #{n[:path]}: concept #{id} is also defined in #{concepts[id]}"
      duplicate_ids += 1
    else
      concepts[id] = key
    end
  end
end

errors = duplicate_ids
warnings = 0
used_papers = {}
papers.each_with_index do |paper, i|
  where = "_data/papers.yml entry #{i + 1}"
  unless paper.is_a?(Hash) && paper["id"].to_s.match?(/\A[a-z0-9]+(-[a-z0-9]+)*\z/)
    puts "ERROR #{where}: needs a lower-case hyphenated `id`"
    errors += 1
    next
  end
  where = "_data/papers.yml #{paper['id']}"
  %w[title authors year].each do |k|
    next unless paper[k].nil? || paper[k].to_s.strip.empty?

    puts "ERROR #{where}: lacks `#{k}`"
    errors += 1
  end
  if paper["type"] && !%w[article book preprint thesis report software dataset].include?(paper["type"].to_s)
    puts "ERROR #{where}: type `#{paper['type']}` should be article, book, preprint, thesis, report, software or dataset"
    errors += 1
  end
  if paper["unverified"]
    puts "warn  #{where}: bibliographic details not yet checked against the source (drop `unverified` once they are)"
    warnings += 1
  end
  if paper["doi"] && !paper["doi"].to_s.match?(%r{\A10\.\d{4,9}/\S+\z})
    puts "ERROR #{where}: `doi` should be bare, like 10.1073/pnas.79.8.2554"
    errors += 1
  end
  if paper["arxiv"] && !paper["arxiv"].to_s.match?(%r{\A(\d{4}\.\d{4,5}|[a-z-]+(\.[A-Z]{2})?/\d{7})(v\d+)?\z})
    puts "ERROR #{where}: `arxiv` should be a bare id like 1706.03762"
    errors += 1
  end
  next unless paper_ids.count(paper["id"].to_s) > 1

  puts "ERROR #{where}: id is used more than once"
  errors += 1
end
err = ->(n, msg) { puts "ERROR #{n[:path]}: #{msg}"; errors += 1 }
warn_ = ->(n, msg) { puts "warn  #{n[:path]}: #{msg}"; warnings += 1 }
# The vocabulary in _data/knowledge.yml must match the stylesheets that draw it.
styles = %w[_sass/_context.scss _sass/_blocks.scss].map { |f| File.read(File.join(ROOT, f)) }.join
layer_ids = KNOWLEDGE["layers"].map { |l| l["id"] }
KNOWLEDGE["kinds"].each do |k|
  where = "_data/knowledge.yml #{k['id']}"
  (puts "ERROR #{where}: layer `#{k['layer']}` is not in `layers`"; errors += 1) unless layer_ids.include?(k["layer"])
  (puts "ERROR #{where}: form must be box or aside"; errors += 1) unless %w[box aside].include?(k["form"])
  (puts "ERROR #{where}: no `blockquote.#{k['id']}` rule in _sass/_context.scss or _blocks.scss"; errors += 1) unless styles.include?("blockquote.#{k['id']}")
end
dup_slugs = KNOWLEDGE["kinds"].group_by { |k| k["slug"] }.select { |_, v| v.size > 1 }.keys
dup_slugs.each { |sl| puts "ERROR _data/knowledge.yml: slug `#{sl}` is used by more than one kind"; errors += 1 }

course_err = lambda do |course, msg|
  puts "ERROR #{course['file']}: #{msg}"
  errors += 1
end

# The courses themselves.
listed = {}
courses.each do |course|
  course_err.(course, "slug `#{course['slug']}` should be lower-case and hyphenated") unless course["slug"].match?(/\A[a-z0-9]+(-[a-z0-9]+)*\z/)
  %w[title summary domain].each { |k| course_err.(course, "lacks `#{k}`") if course[k].to_s.strip.empty? }
  course_err.(course, "domain `#{course['domain']}` is not in _data/domains.yml (#{domains.join(', ')})") unless domains.include?(course["domain"])
  course_err.(course, "`parts` is empty") if Array(course["parts"]).empty?
  Array(course["parts"]).each do |part|
    Array(part["reading"]).each do |id|
      course_err.(course, "part `#{part['title']}` lists unknown reading `#{id}` (add it to _data/papers.yml)") unless paper_ids.include?(id.to_s)
      used_papers[id.to_s] = true
    end
  end
  if course["reference"] && !File.exist?(File.join(ROOT, course["reference"]))
    course_err.(course, "reference #{course['reference']} does not exist")
  end
  Array(course["parts"]).each do |part|
    course_err.(course, "a part lacks `title`") if part["title"].to_s.strip.empty?
    course_err.(course, "part `#{part['title']}` has no notes") if Array(part["notes"]).empty?
    Array(part["notes"]).each do |key|
      course_err.(course, "#{key} is also listed in #{listed[key]}") if listed[key]
      listed[key] ||= course["slug"]
    end
  end
end
(notes.keys - listed.keys).each do |key|
  puts "warn  #{notes[key][:path]}: not listed in any course (_data/courses/); the shelf shows it under More notes"
  warnings += 1
end

courses.each do |course|
  Array(course["parts"]).each do |part|
    Array(part["notes"]).each do |key|
      next if filter && !key.start_with?(filter)

      n = notes[key]
      if n.nil?
        puts "ERROR #{course['file']} lists #{key}, but _notes/#{key}.md does not exist"
        errors += 1
        next
      end
      next unless n[:written]
      next if course["legacy"]

      # Citations. Unknown ids matter for every written note; the rest of the citation
      # standard only for notes that follow it.
      cited_here = n[:body].scan(/\{%-?\s*cite[t]?\s+(.*?)\s*-?%\}/m).flatten.flat_map do |markup|
        markup.split(/[\s,]+/).reject { |t| t.empty? || t.include?("=") }.map(&:downcase)
      end
      (cited_here + Array(n[:data]["cites"]).map { |c| c.to_s.downcase }).uniq.each do |id|
        used_papers[id] = true
        err.(n, "cites unknown paper `#{id}` (add it to _data/papers.yml)") unless paper_ids.include?(id)
      end
      if n[:body].include?("bibliography.html")
        msg = "uses the retired bibliography include; cite with {% cite id %} and the list is added by the layout"
        course["legacy"] ? warn_.(n, msg) : err.(n, msg)
      end
      next if course["legacy"]

      d, body = n[:data], n[:body]

      %w[title date excerpt hook goals tags].each { |k| err.(n, "front matter lacks `#{k}`") if d[k].nil? || d[k].to_s.strip.empty? }
      goals = Array(d["goals"])
      err.(n, "`goals` should have 2 to 4 items, has #{goals.size}") unless (2..4).cover?(goals.size)
      err.(n, "`hook` should be one sentence, under 45 words") if d["hook"].to_s.split.size > 45
      err.(n, "set neither `layout` nor `permalink`; the collection defaults apply") if d["layout"] || d["permalink"]
      defines = Array(d["defines"])
      err.(n, "`defines` is empty: a note must introduce at least one concept") if defines.empty?

      # A concept's anchor may be a heading or the id of a typed block (a definition, say).
      block_ids = body.scan(/^\{:[^}]*?#([A-Za-z][\w:-]*)/).flatten
      block_ids.group_by { |i| i }.select { |_, v| v.size > 1 }.each_key { |i| err.(n, "block id `#{i}` is used more than once") }
      ids = heading_ids(body) + block_ids
      defines.each do |c|
        err.(n, "`defines` entry needs id, name and anchor: #{c.inspect}") unless c.is_a?(Hash) && c["id"] && c["name"] && c["anchor"]
        next unless c.is_a?(Hash) && c["anchor"]

        err.(n, "concept #{c['id']}: no heading with id `#{c['anchor']}`") unless ids.include?(c["anchor"])
        err.(n, "concept id `#{c['id']}` should be lower-case and hyphenated") unless c["id"].to_s.match?(/\A[a-z0-9]+(-[a-z0-9]+)*\z/)
      end

      # Typed blocks (see _data/knowledge.yml): statements need a title to be findable out of
      # context, and a concept should be introduced by a .definition rather than bold text.
      titled = %w[definition assumption theorem lemma proposition property corollary law hypothesis]
      body.scan(/^\{:([^}]*)\}$/).flatten.each do |attrs|
        kind = attrs[/(?<![\w"])\.(#{titled.join('|')})(?![\w-])/, 1]
        warn_.(n, "`.#{kind}` block has no title=\"...\"; the statements index lists it by title") if kind && attrs !~ /title="[^"]+"/
      end
      # Justify slot: a theorem, lemma, proposition or corollary is followed, in its section, by a
      # .proof or .derive block, or cites its source in the statement itself.
      lines = body.lines
      lines.each_with_index do |line, i|
        next unless line =~ /\A\{:[^}]*(?<![\w"])\.(theorem|lemma|proposition|corollary)(?![\w-])[^}]*\}\s*\z/

        title = line[/title="([^"]*)"/, 1] || line[/#([\w-]+)/, 1] || "(untitled)"
        j = i - 1
        j -= 1 while j >= 0 && lines[j].start_with?(">")
        statement = lines[(j + 1)...i].join
        section = lines[(i + 1)..].take_while { |l| l !~ /\A\#+ / }.join
        next if statement.include?("cite ") || section =~ /^\{:[^}]*(?<![\w"])\.(proof|derive)(?![\w-])/

        warn_.(n, "`#{title}` is a claim with no .proof or .derive block after it and no citation in the statement (justify slot)")
      end
      body.scan(/^\{:[^}]*?about="([^"]*)"/).flatten.flat_map(&:split).uniq.each do |id|
        warn_.(n, "a block says about=\"#{id}\", which is not a concept id") unless concepts.key?(id)
      end
      untyped = defines.select { |c| c.is_a?(Hash) && c["anchor"] && !block_ids.include?(c["anchor"]) }
      warn_.(n, "#{untyped.size} of #{defines.size} concepts are not introduced by a .definition block (#{untyped.first(3).map { |c| c['id'] }.join(', ')}#{untyped.size > 3 ? ', ...' : ''})") unless untyped.empty?

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

      warn_.(n, "cites no sources; add {% cite id %} for each result, dataset and named method (works go in _data/papers.yml)") if cited_here.empty? && Array(d["cites"]).empty?
      Array(d["relates"]).each do |id|
        err.(n, "relates unknown project `#{id}` (no _projects/#{id}.md)") unless project_ids.include?(id.to_s)
      end

      ctx = d["context"]
      if ctx
        if !ctx.is_a?(Hash)
          err.(n, "`context` should be a mapping with origin, timeline and next")
        else
          err.(n, "`context.origin` is empty; say who posed the problem, when and why") if ctx["origin"].to_s.strip.empty?
          Array(ctx["timeline"]).each do |step|
            unless step.is_a?(Hash) && step["year"] && !step["text"].to_s.strip.empty?
              err.(n, "`context.timeline` entries need a year and a text: #{step.inspect}")
              next
            end
            err.(n, "`context.timeline` cites unknown paper `#{step['cite']}`") if step["cite"] && !paper_ids.include?(step["cite"].to_s)
            used_papers[step["cite"].to_s] = true if step["cite"]
          end
          years = Array(ctx["timeline"]).map { |t| t.is_a?(Hash) ? t["year"].to_i : 0 }
          warn_.(n, "`context.timeline` should run oldest first") unless years == years.sort
        end
      end

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
        # `#id` and key="value" attributes (ids for cross-references, titles for theorem-like blocks).
        attrs.gsub(/\w+="[^"]*"/, "").split.each do |tok|
          next if tok.start_with?("#")

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
        unless src
          err.(n, "figure without src")
          next
        end
        err.(n, "figure #{src}: missing _includes/fig/#{src}.svg (run tools/figures/build.py)") unless File.exist?(File.join(ROOT, "_includes/fig/#{src}.svg"))
        err.(n, "figure #{src}: no alt text") unless args =~ /alt="[^"]{12,}"/
        err.(n, "figure #{src}: no caption") unless args =~ /caption="[^"]{12,}"/
      end

      # Links to other notes: the note must exist and the anchor must be one of its headings.
      body.scan(%r{/notes/([a-z0-9/-]+?)/' \| relative_url \}\}(?:#([a-z0-9-]+))?}).each do |target, anchor|
        t = notes[target]
        if t.nil?
          err.(n, "links to /notes/#{target}/, which does not exist")
        elsif anchor && t[:written] && !(heading_ids(t[:body]) + t[:body].scan(/^\{:[^}]*?#([A-Za-z][\w:-]*)/).flatten).include?(anchor)
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

# Threads: essays that route through notes of several courses (_threads/<slug>.md).
Dir[File.join(ROOT, "_threads/*.md")].sort.each do |path|
  rel = path.sub("#{ROOT}/", "")
  data, body = front_matter(path)
  t = { path: rel }
  next if body.strip.empty? && data["route"].nil?

  %w[title date excerpt].each { |k| err.(t, "front matter lacks `#{k}`") if data[k].to_s.strip.empty? }
  route = Array(data["route"])
  err.(t, "`route` should list at least 3 notes; a thread connects things") if route.size < 3
  courses_hit = []
  route.each do |stop|
    key = stop.is_a?(Hash) ? stop["note"].to_s : ""
    if key.empty?
      err.(t, "route entry needs `note`: #{stop.inspect}")
      next
    end
    err.(t, "route note `#{key}` does not exist (no _notes/#{key}.md)") unless notes.key?(key)
    err.(t, "route stop `#{key}` has no `why`") if stop["why"].to_s.strip.empty?
    courses_hit << (listed[key] || key.split("/")[0..1].join("/"))
  end
  warn_.(t, "route stays inside one course; a thread should cross courses") if route.size >= 3 && courses_hit.uniq.size < 2
  cited = body.scan(/\{%-?\s*cite[t]?\s+(.*?)\s*-?%\}/m).flatten.flat_map { |m| m.split(/[\s,]+/).reject { |x| x.empty? || x.include?("=") }.map(&:downcase) }
  (cited + Array(data["cites"]).map { |c| c.to_s.downcase }).uniq.each do |id|
    used_papers[id] = true
    err.(t, "cites unknown paper `#{id}` (add it to _data/papers.yml)") unless paper_ids.include?(id)
  end
  warn_.(t, "cites no sources") if cited.empty? && Array(data["cites"]).empty?
  err.(t, "body has an em dash; rewrite the sentence") if body.include?("—")
end

if filter.nil?
  paper_ids.each do |id|
    next if id.empty? || used_papers[id]

    puts "warn  _data/papers.yml #{id}: no note cites it yet"
    warnings += 1
  end
end

puts "#{errors} error(s), #{warnings} warning(s)"
exit(errors.zero? ? 0 : 1)
