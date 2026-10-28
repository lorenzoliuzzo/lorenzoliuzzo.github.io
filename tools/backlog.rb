#!/usr/bin/env ruby
# Ranks the planned notes (stubs: a note with front matter and an empty body) so the next
# one to write is the one that unblocks the most, and prepares the review queue.
#
#   ruby tools/backlog.rb                  # the 15 best stubs that can be written now
#   ruby tools/backlog.rb --all            # every stub, blocked ones included
#   ruby tools/backlog.rb --course NAME    # only courses whose slug contains NAME
#   ruby tools/backlog.rb --limit N        # show N rows
#   ruby tools/backlog.rb --queue          # written notes nobody has read, unverified papers
#   ruby tools/backlog.rb --check          # validate the `plan:` blocks (exit 1 on errors)
#   ruby tools/backlog.rb --json           # the whole result as JSON on stdout
#   ruby tools/backlog.rb --write          # write _data/backlog.json for /notes/backlog/
#
# Ranking, in this order:
#   1. unblocks: how many other notes (written or planned) sit downstream of the stub,
#      following `requires` through the concept ids it defines, transitively.
#   2. studying: courses listed under `current` in _data/study.yml come first among ties.
#   3. course order, then position in the course.
# A stub is ready when every concept it requires is defined by a written note. A blocked
# stub lists the planned notes it waits for.
#
# A stub may carry a `plan:` block that the layouts ignore:
#   plan:
#     sources: [kardar-2007, study/stat-mech/lecture-4]   # paper ids, or paths under study/
#     figures: ["domain-wall droplet"]                      # figure ideas
#     verify:  ["Tc = 2.269 J"]                             # claims to check before sign-off
#     lab: project                                          # a `labs` id in the course file
# Standard library only.
require "yaml"
require "date"
require "json"

Encoding.default_external = Encoding::UTF_8
ROOT = File.expand_path("..", __dir__)
PLAN_KEYS = %w[sources figures verify lab].freeze

def front_matter(path)
  raw = File.read(path)
  m = raw.match(/\A---\n(.*?)\n---\n?(.*)\z/m) or return [{}, raw]
  [YAML.safe_load(m[1], permitted_classes: [Date, Time]) || {}, m[2]]
end

def compute(root)
  courses = Dir[File.join(root, "_data/courses/*.yml")].sort.map do |p|
    YAML.load_file(p).merge("slug" => File.basename(p, ".yml"))
  end
  study_path = File.join(root, "_data/study.yml")
  current = File.exist?(study_path) ? Array((YAML.load_file(study_path) || {})["current"]).map(&:to_s) : []
  papers_path = File.join(root, "_data/papers.yml")
  papers = File.exist?(papers_path) ? Array(YAML.load_file(papers_path)).select { |p| p.is_a?(Hash) } : []

  notes = {}
  Dir[File.join(root, "_notes/**/*.md")].sort.each do |path|
    key = path.sub("#{root}/_notes/", "").sub(/\.md\z/, "")
    fm, body = front_matter(path)
    notes[key] = { key: key, fm: fm, body: body, stub: body.strip.empty? && !fm.empty?, title: fm["title"] || key }
  end

  where = {}
  courses.each do |c|
    pos = 0
    Array(c["parts"]).each_with_index do |part, pi|
      Array(part["notes"]).each { |k| where[k] ||= [c["slug"], pi, pos]; pos += 1 }
    end
  end
  course_title = courses.to_h { |c| [c["slug"], c["short"] || c["title"] || c["slug"]] }

  definer = {}
  notes.each_value { |n| Array(n[:fm]["defines"]).each { |d| definer[d["id"].to_s] ||= n[:key] if d.is_a?(Hash) } }

  down = Hash.new { |h, k| h[k] = [] }
  notes.each_value do |n|
    Array(n[:fm]["requires"]).each do |r|
      d = definer[r.to_s]
      down[d] << n[:key] if d && d != n[:key]
    end
  end
  reach = lambda do |start|
    seen = {}
    stack = [start]
    until stack.empty?
      cur = stack.pop
      down[cur].each { |nx| next if seen[nx] || nx == start; seen[nx] = true; stack << nx }
    end
    seen.keys
  end

  order = courses.each_with_index.to_h { |c, i| [c["slug"], i] }
  rows = notes.values.select { |n| n[:stub] && where[n[:key]] }.map do |n|
    waiting = Array(n[:fm]["requires"]).map { |r| definer[r.to_s] }.compact.uniq.select { |k| notes[k][:stub] }
    missing = Array(n[:fm]["requires"]).map(&:to_s).reject { |r| definer[r] }
    slug, pi, pos = where[n[:key]]
    plan = n[:fm]["plan"].is_a?(Hash) ? n[:fm]["plan"] : {}
    direct = down[n[:key]].uniq
    { "key" => n[:key], "url" => "/notes/#{n[:key]}/", "title" => n[:title].to_s, "hook" => n[:fm]["hook"].to_s,
      "course" => slug, "course_title" => course_title[slug], "part" => pi, "pos" => pos,
      "unblocks" => reach.call(n[:key]).size,
      "leads_to" => direct.first(3).map { |k| notes[k][:title].to_s },
      "studying" => current.include?(slug),
      "ready" => waiting.empty? && missing.empty?,
      "waiting" => waiting.map { |k| { "key" => k, "title" => notes[k][:title].to_s } }, "missing" => missing,
      "sources" => Array(plan["sources"]).map(&:to_s), "figures" => Array(plan["figures"]).map(&:to_s),
      "verify" => Array(plan["verify"]).map(&:to_s), "lab" => plan["lab"].to_s, "has_plan" => !plan.empty? }
  end
  rows.sort_by! { |r| [-r["unblocks"], r["studying"] ? 0 : 1, order[r["course"]], r["part"], r["pos"]] }

  cited = Hash.new(0)
  notes.each_value { |n| n[:body].scan(/\{%\s*cite[t]?\s+([\w-]+)/) { |m| cited[m[0]] += 1 } }
  unverified = papers.select { |p| p["unverified"] }.map do |p|
    link = p["doi"] ? "https://doi.org/#{p['doi']}" : (p["arxiv"] ? "https://arxiv.org/abs/#{p['arxiv']}" : p["url"].to_s)
    { "id" => p["id"].to_s, "title" => p["title"].to_s, "authors" => p["authors"].to_s, "year" => p["year"], "link" => link, "cited_by" => cited[p["id"].to_s] }
  end.sort_by { |p| [-p["cited_by"], p["id"]] }

  unread = notes.values.reject { |n| n[:stub] || n[:fm].empty? || n[:fm]["human_verified"] }.map do |n|
    slug = (where[n[:key]] || [nil])[0]
    { "key" => n[:key], "url" => "/notes/#{n[:key]}/", "title" => n[:title].to_s, "course" => slug.to_s,
      "course_title" => course_title[slug].to_s, "date" => n[:fm]["date"].to_s[0, 10], "words" => n[:body].split.size,
      "figures" => n[:body].scan(/include fig\.html/).size, "cites" => n[:body].scan(/\{%\s*cite/).size }
  end.sort_by { |n| [n["date"], n["course"], n["key"]] }

  thin = notes.values.reject { |n| n[:stub] || n[:fm].empty? }.map { |n| [n, n[:body].split.size] }.select { |_, w| w < 300 }.map do |n, w|
    { "key" => n[:key], "url" => "/notes/#{n[:key]}/", "title" => n[:title].to_s, "words" => w, "course" => (where[n[:key]] || [""])[0].to_s }
  end.sort_by { |n| [n["words"], n["key"]] }

  { "generated" => Date.today.to_s,
    "summary" => { "planned" => rows.size, "ready" => rows.count { |r| r["ready"] }, "blocked" => rows.count { |r| !r["ready"] },
                   "written" => notes.values.count { |n| !n[:stub] && !n[:fm].empty? }, "unread" => unread.size, "thin" => thin.size,
                   "unverified_papers" => unverified.size },
    "current" => current, "ready" => rows.select { |r| r["ready"] }, "blocked" => rows.reject { |r| r["ready"] },
    "unread" => unread, "thin" => thin, "unverified_papers" => unverified, "_papers" => papers.map { |p| p["id"].to_s },
    "_labs" => courses.to_h { |c| [c["slug"], Array(c["labs"]).map { |l| l["id"].to_s }] } }
end

def check_plans(res)
  errors = []
  (res["ready"] + res["blocked"]).each do |r|
    next unless r["has_plan"]
    fm = front_matter(File.join(ROOT, "_notes/#{r['key']}.md"))[0]
    plan = fm["plan"]
    (plan.keys.map(&:to_s) - PLAN_KEYS).each { |k| errors << "#{r['key']}: unknown plan key `#{k}` (allowed: #{PLAN_KEYS.join(', ')})" }
    %w[sources figures verify].each { |k| errors << "#{r['key']}: plan.#{k} must be a list" if plan.key?(k) && !plan[k].is_a?(Array) }
    r["sources"].each do |s|
      next if s.start_with?("study/") || res["_papers"].include?(s)
      errors << "#{r['key']}: plan source `#{s}` is neither a paper id in _data/papers.yml nor a path under study/"
    end
    errors << "#{r['key']}: plan.lab `#{r['lab']}` is not a labs id of course #{r['course']}" if !r["lab"].empty? && !Array(res["_labs"][r["course"]]).include?(r["lab"])
  end
  errors
end

if $PROGRAM_NAME == __FILE__
  args = ARGV.dup
  as_json = args.delete("--json")
  show_all = args.delete("--all")
  want_queue = args.delete("--queue")
  want_check = args.delete("--check")
  want_write = args.delete("--write")
  course_filter = (i = args.index("--course")) ? (args.delete_at(i); args.delete_at(i)) : nil
  limit = (i = args.index("--limit")) ? (args.delete_at(i); args.delete_at(i).to_i) : 15

  res = compute(ROOT)
  public_res = res.reject { |k, _| k.start_with?("_") }

  if want_write
    File.write(File.join(ROOT, "_data/backlog.json"), JSON.pretty_generate(public_res) + "\n")
    s = res["summary"]
    puts "wrote _data/backlog.json: #{s['planned']} planned (#{s['ready']} ready), #{s['unread']} unread, #{s['unverified_papers']} unverified papers"
    exit
  end
  if want_check
    errs = check_plans(res)
    puts errs.empty? ? "plan blocks ok (#{(res['ready'] + res['blocked']).count { |r| r['has_plan'] }} stubs have one)" : errs.map { |e| "ERROR #{e}" }
    exit(errs.empty? ? 0 : 1)
  end
  if as_json
    puts JSON.pretty_generate(public_res)
    exit
  end
  if want_queue
    puts "#{res['unread'].size} written notes not yet signed off (oldest first):"
    res["unread"].first(limit).each { |n| puts format("  %-10s %5d words  %d fig  %d cites  %s", n["date"], n["words"], n["figures"], n["cites"], n["key"]) }
    puts "\n#{res['unverified_papers'].size} unverified papers (most cited first):"
    res["unverified_papers"].first(limit).each { |p| puts format("  %-26s cited by %2d  %s", p["id"], p["cited_by"], p["link"]) }
    exit
  end

  rows = res["ready"] + res["blocked"]
  rows = rows.select { |r| r["course"].include?(course_filter) } if course_filter
  rows.sort_by! { |r| [-r["unblocks"], r["studying"] ? 0 : 1, r["course"], r["part"], r["pos"]] } if course_filter
  shown = show_all ? rows : rows.select { |r| r["ready"] }
  s = res["summary"]
  puts "#{s['planned']} planned notes (#{s['ready']} ready, #{s['blocked']} blocked), #{s['written']} written."
  puts "Studying: #{res['current'].empty? ? '(none set: add `current: [course-slug]` to _data/study.yml)' : res['current'].join(', ')}"
  puts
  if shown.empty?
    puts "Nothing to show."
  else
    w = shown.first(limit).map { |r| r["key"].length }.max
    puts format("%-#{w}s  %8s  %5s  %s", "note", "unblocks", "study", "status")
    shown.first(limit).each do |r|
      status = if r["ready"] then (r["has_plan"] ? "ready, planned" : "ready")
               else "blocked by " + (r["waiting"].map { |x| x["key"] } + r["missing"].map { |m| "?#{m}" }).join(", ")
               end
      puts format("%-#{w}s  %8d  %5s  %s", r["key"], r["unblocks"], r["studying"] ? "yes" : "", status)
    end
    puts "... #{shown.size - limit} more (--limit N)" if shown.size > limit
  end
end
