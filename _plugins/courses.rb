# The notes are organised in courses, one data file each (_data/courses/<slug>.yml),
# grouped on the shelf by domain (_data/domains.yml). This plugin turns those files
# into everything the shelf, the course pages, the glossary and the search box read:
#
#   site.data["courses"]         an ordered array (domain order, then `order`, then title).
#                                Each course keeps its file's fields and gains
#                                slug, url, domain, written, planned, total, pct, verified, status,
#                                first_url/first_title, concepts, reads_from, feeds, and per
#                                part: slug, hue, written, planned and `items`, the notes
#                                in reading order with title, url, summary and concepts.
#   site.data["domain_groups"]   the domains with their courses and counts
#   site.data["notes_stats"]     counts for the shelf header
#   site.data["concept_list"]    the glossary: concepts sorted by name, with where each
#                                is defined and which notes use it
#   site.data["loose_notes"]     notes no course lists (the shelf shows them under "More")
#   /notes/<slug>/               one page per course, layout `course`
#   /notes-index.json            the search index of the shelf
#
# It runs in two steps. The first, before anything else, turns the data-file hash Jekyll
# builds from the directory into the array the other plugins and templates expect. The
# second runs after planned_notes.rb and concept_index.rb, because it needs to know
# which notes are written and who defines which concept.
require "json"

module MyThingsLab
  module Courses
    module_function

    def note_key(relative_path)
      relative_path.to_s.sub(%r{\A_notes/}, "").sub(/\.[^.\/]+\z/, "")
    end

    def slugify(text)
      Jekyll::Utils.slugify(text.to_s)
    end

    # One plain sentence for a row: the front-matter excerpt, or else the first
    # paragraph of the body with the markup stripped.
    def summary_for(doc)
      text = doc.data["excerpt"].to_s.strip
      if text.empty?
        para = doc.content.to_s.split(/\n\s*\n/).map(&:strip).find do |chunk|
          !chunk.empty? && chunk !~ /\A(#|>|\||[-*+]\s|\d+\.\s|\{%|<|\$\$|---)/
        end
        text = para.to_s
      end
      text = text.gsub(/\[([^\]]*)\]\([^)]*\)/, '\1').gsub(/[*_`$]/, "").gsub(/\s+/, " ").strip
      text.length > 170 ? "#{text[0, 167].sub(/\s+\S*\z/, '')}…" : text
    end

    def sort_key(name)
      base = name.to_s.unicode_normalize(:nfd).gsub(/\p{Mn}/, "").downcase.gsub(/[^a-z0-9]/, "")
      base.empty? ? name.to_s.downcase : base
    end

    def letter_of(name)
      first = name.to_s.unicode_normalize(:nfd).gsub(/\p{Mn}/, "").gsub(/[^A-Za-z0-9]/, "")[0]
      first && first =~ /[A-Za-z]/ ? first.upcase : "#"
    end
  end

  if defined?(Jekyll::Generator)
    class CoursesNormalizer < Jekyll::Generator
      safe true
      priority :highest

      def generate(site)
        raw = site.data["courses"]
        list = raw.is_a?(Hash) ? raw.map { |slug, course| course.merge("slug" => (course["slug"] || slug).to_s) } : Array(raw)
        order = Array(site.data["domains"]).each_with_index.each_with_object({}) { |(d, i), h| h[d["id"]] = i }
        list = list.sort_by do |course|
          [order.fetch(course["domain"], order.size), course["order"] || 1000, course["title"].to_s.downcase]
        end
        site.data["courses"] = list
      end
    end

    class CoursePagesGenerator < Jekyll::Generator
      safe true
      priority :low

      def generate(site)
        collection = site.collections["notes"]
        return if collection.nil?

        @site = site
        docs = collection.docs.each_with_object({}) { |doc, h| h[Courses.note_key(doc.relative_path)] = doc }
        stubs = Array(site.data["planned_notes"]).each_with_object({}) { |s, h| h[Courses.note_key(s["path"])] = s }
        concepts = site.data["concepts"] || {}
        domains = Array(site.data["domains"]).map(&:dup)
        courses = site.data["courses"]

        note_course = {}
        courses.each do |course|
          course["url"] = "/notes/#{course['slug']}/"
          course["written"] = course["planned"] = 0
          course["concepts"] = []
          Array(course["parts"]).each_with_index do |part, pi|
            part["slug"] = Courses.slugify(part["title"])
            part["hue"] = (pi % 6) + 1
            part["items"] = Array(part["notes"]).map { |key| item_for(key, docs[key], stubs[key], course, concepts) }
            part["written"] = part["items"].count { |i| i["written"] }
            part["planned"] = part["items"].size - part["written"]
            course["written"] += part["written"]
            course["planned"] += part["planned"]
            part["items"].each do |item|
              note_course[item["key"]] = course
              course["concepts"].concat(item["concepts"])
            end
          end
          course["total"] = course["written"] + course["planned"]
          course["pct"] = course["total"].zero? ? 0 : (course["written"] * 100.0 / course["total"]).round
          course["status"] = course["written"].zero? ? "planned" : (course["planned"].zero? ? "complete" : "in-progress")
          course["status_label"] = { "planned" => "Planned", "in-progress" => "In progress", "complete" => "Written" }[course["status"]]
          first = course["parts"].flat_map { |p| p["items"] }.find { |i| i["written"] }
          course["first_url"] = first && first["url"]
          course["first_title"] = first && first["title"]
          course["verified"] = course["parts"].flat_map { |p| p["items"] }.count { |i| i["state"] == "verified" }
          course["updated"] = course["parts"].flat_map { |p| p["items"] }.map { |i| i["date"] }.compact.max
          course["reads_from"] = []
          course["feeds"] = []
        end

        link_concepts(site, docs, concepts, note_course, courses)
        group_by_domain(site, courses, domains, docs, note_course)
        write_pages(site, courses, domains, concepts)
      end

      private

      def item_for(key, doc, stub, course, concepts)
        defined_here = concepts.values.select { |c| c["note"] == key }
        chips = defined_here.map do |c|
          href = c["url"] && (c["anchor"].to_s.empty? ? c["url"] : "#{c['url']}##{c['anchor']}")
          { "id" => c["id"], "name" => c["name"], "href" => href, "planned" => c["planned"] }
        end
        if doc
          { "key" => key, "written" => true, "title" => doc.data["title"].to_s.empty? ? File.basename(key) : doc.data["title"],
            "url" => doc.url, "summary" => Courses.summary_for(doc), "date" => doc.data["date"] && doc.data["date"].to_time.strftime("%Y-%m-%d"),
            "concepts" => chips, "course" => course["slug"], "state" => doc.data["verification_state"].to_s }
        else
          { "key" => key, "written" => false, "title" => (stub && stub["title"]) || File.basename(key),
            "url" => nil, "summary" => "", "date" => nil, "concepts" => chips, "course" => course["slug"], "state" => "" }
        end
      end

      # Cross-course prerequisites, the glossary, and which notes use which concept.
      def link_concepts(site, docs, concepts, note_course, courses)
        by_slug = courses.each_with_object({}) { |c, h| h[c["slug"]] = c }
        used_by = Hash.new { |h, k| h[k] = [] }
        reads = Hash.new { |h, k| h[k] = Hash.new { |hh, kk| hh[kk] = [] } }

        docs.each do |key, doc|
          mine = note_course[key]
          Concepts.required_ids(doc.data).each do |id|
            concept = concepts[id] or next
            used_by[id] << { "title" => doc.data["title"], "url" => doc.url, "course" => mine && mine["slug"] }
            owner = note_course[concept["note"]]
            next if mine.nil? || owner.nil? || owner["slug"] == mine["slug"]

            reads[mine["slug"]][owner["slug"]] << concept["name"]
          end
        end

        reads.each do |slug, from|
          from.each do |owner_slug, names|
            names = names.uniq
            by_slug[slug]["reads_from"] << { "slug" => owner_slug, "title" => by_slug[owner_slug]["title"], "url" => by_slug[owner_slug]["url"],
                                             "domain" => by_slug[owner_slug]["domain"], "count" => names.size, "names" => names.first(5) }
            by_slug[owner_slug]["feeds"] << { "slug" => slug, "title" => by_slug[slug]["title"], "url" => by_slug[slug]["url"],
                                              "domain" => by_slug[slug]["domain"], "count" => names.size, "names" => names.first(5) }
          end
        end
        courses.each { |c| %w[reads_from feeds].each { |k| c[k].sort_by! { |e| [-e["count"], e["title"]] } } }

        list = concepts.values.map do |c|
          course = note_course[c["note"]]
          {
            "id" => c["id"], "name" => c["name"], "letter" => Courses.letter_of(c["name"]), "key" => Courses.sort_key(c["name"]),
            "url" => c["url"] && (c["anchor"].to_s.empty? ? c["url"] : "#{c['url']}##{c['anchor']}"),
            "planned" => c["planned"], "note_title" => c["title"], "note_url" => c["url"],
            "course" => course && (course["short"] || course["title"]), "course_url" => course && course["url"], "domain" => course && course["domain"],
            "used_by" => used_by[c["id"]].sort_by { |u| u["title"].to_s }
          }
        end
        site.data["concept_list"] = list.sort_by { |c| [c["key"], c["name"]] }
      end

      def group_by_domain(site, courses, domains, docs, note_course)
        known = domains.map { |d| d["id"] }
        stray = courses.reject { |c| known.include?(c["domain"]) }
        domains << { "id" => "other", "title" => "Other", "blurb" => "", "hue" => 6 } unless stray.empty?
        domains.each do |domain|
          mine = courses.select { |c| c["domain"] == domain["id"] || (domain["id"] == "other" && !known.include?(c["domain"])) }
          mine.each do |c|
            c["domain"] = domain["id"]
            c["domain_title"] = domain["title"]
            c["domain_hue"] = domain["hue"]
          end
          domain["courses"] = mine
          domain["written"] = mine.sum { |c| c["written"] }
          domain["planned"] = mine.sum { |c| c["planned"] }
        end
        # Cross-course entries carry the domain id; give them the hue as well.
        hue = domains.each_with_object({}) { |d, h| h[d["id"]] = d["hue"] }
        courses.each { |c| %w[reads_from feeds].each { |k| c[k].each { |e| e["hue"] = hue[e["domain"]] || 6 } } }
        site.data["domain_groups"] = domains.reject { |d| d["courses"].empty? }
        site.data["concept_list"].each { |c| c["hue"] = hue[c["domain"]] || 6 }

        loose = docs.reject { |key, _| note_course.key?(key) }.values.sort_by { |d| d.data["title"].to_s.downcase }
        site.data["loose_notes"] = loose.map { |d| { "title" => d.data["title"], "url" => d.url, "summary" => Courses.summary_for(d), "tags" => Array(d.data["tags"]) } }
        site.data["notes_stats"] = {
          "courses" => courses.size, "written" => courses.sum { |c| c["written"] }, "planned" => courses.sum { |c| c["planned"] },
          "concepts" => (site.data["concepts"] || {}).size
        }
      end

      def write_pages(site, courses, domains, concepts)
        courses.each do |course|
          page = Jekyll::PageWithoutAFile.new(site, site.source, File.join("notes", course["slug"]), "index.html")
          page.content = ""
          page.data.merge!(
            "layout" => "course", "title" => course["title"], "description" => course["summary"],
            "classes" => "wide course-page", "author_profile" => false, "breadcrumbs" => true,
            "course" => course, "toc" => false,
            # jekyll-last-modified-at wants a file on disk for every page, and this one has none.
            "last_modified_at" => site.time
          )
          site.pages << page
        end

        index = []
        courses.each do |course|
          course["parts"].each do |part|
            part["items"].each do |item|
              index << { "k" => "note", "t" => item["title"], "u" => item["url"], "c" => course["title"], "p" => part["title"],
                         "d" => course["domain_title"], "e" => item["summary"], "w" => item["written"] ? 1 : 0,
                         "x" => item["concepts"].map { |c| c["name"] }.join(" · ") }
            end
          end
        end
        site.data["concept_list"].each do |c|
          index << { "k" => "concept", "t" => c["name"], "u" => c["url"], "c" => c["course"], "n" => c["note_title"], "w" => c["planned"] ? 0 : 1 }
        end
        page = Jekyll::PageWithoutAFile.new(site, site.source, "", "notes-index.json")
        page.content = JSON.generate(index) + "\n"
        page.data["layout"] = nil
        page.data["render_with_liquid"] = false
        page.data["sitemap"] = false
        site.pages << page
      end
    end
  end
end
