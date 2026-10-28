# Typed blocks: a blockquote followed by `{: .definition ...}` (or theorem, trap, ...) is a
# piece of knowledge of a known kind; the kinds are listed in _data/knowledge.yml.
#
# This generator reads the source of every written note and
#   1. gives each typed block an id when it has none (kind prefix + title slug, or kind
#      prefix + running number), so every block can be linked from anywhere;
#   2. records the blocks in site.data["knowledge"] for /notes/knowledge/;
#   3. leaves doc.data["statements"] (kind => count) for templates that want a summary.
#
# The rewrite happens in memory on doc.content only; the files on disk are untouched.
module MyThingsLab
  module Knowledge
    module_function

    BLOCK = /^((?:>[^\n]*\n)+)\{:\s*([^}\n]*)\}[ \t]*$/.freeze

    def slugify(text)
      text.to_s.downcase.gsub(/\$[^$]*\$/, " ").gsub(/[^a-z0-9]+/, "-").gsub(/\A-+|-+\z/, "")
    end

    def excerpt(quote)
      text = quote.lines.map { |l| l.sub(/\A>\s?/, "") }.join.strip
      text = text.gsub(/\{%.*?%\}/m, "").gsub(/\n{2,}/, "\n\n")
      text.length > 360 ? text[0, 360].sub(/\s+\S*\z/, "") + " ..." : text
    end

    # The whole block as Markdown, without the `> ` prefix and without Liquid tags.
    def full_text(quote)
      quote.lines.map { |l| l.sub(/\A>\s?/, "") }.join.gsub(/\{%.*?%\}/m, "").strip
    end

    # Returns [new_content, [blocks]] for one note's source.
    def scan(content, kinds, key)
      used = Hash.new(0)
      taken = content.scan(/#([A-Za-z][\w:-]*)/).flatten
      found = []
      out = content.gsub(BLOCK) do
        whole, quote, attrs = Regexp.last_match(0), Regexp.last_match(1), Regexp.last_match(2)
        kind = attrs.scan(/(?<![\w"])\.([a-z-]+)/).flatten.find { |c| kinds[c] }
        next whole unless kind

        id = attrs[/(?<![\w&])#([A-Za-z][\w:-]*)/, 1]
        title = attrs[/title="([^"]*)"/, 1]
        used[kind] += 1
        unless id
          base = "#{kinds[kind]['slug']}-#{title && !slugify(title).empty? ? slugify(title) : used[kind]}"
          id = base
          id = "#{base}-#{used[kind]}" while taken.include?(id)
          taken << id
          attrs = "#{attrs.strip} ##{id}"
        end
        attrs = "#{attrs.strip} data-kind=\"#{kind}\" data-layer=\"#{kinds[kind]['layer']}\"" unless attrs.include?("data-kind=")
        about = attrs[/about="([^"]*)"/, 1].to_s.split
        found << { "kind" => kind, "id" => id, "title" => title.to_s, "text" => excerpt(quote), "full" => full_text(quote), "about" => about }
        "#{quote}{: #{attrs.strip}}"
      end
      [out, found]
    end
  end

  module Knowledge
    module_function

    RESULT = %w[theorem lemma proposition property corollary law hypothesis].freeze
    BUCKET = { "define" => "extra_definitions", "claim" => "results", "justify" => "derivations", "interpret" => "meaning", "use" => "use", "caution" => "caution" }.freeze
    # The six slots of a concept (see claude/site-design-pattern.md): define, claim, justify,
    # instance, boundary, practice. `slots` says which are filled; `score` counts them.
    SLOTS = %w[define claim justify instance boundary practice].freeze
    INSTANCE = %w[example application try algorithm].freeze
    PRACTICE = %w[exercise try].freeze

    # Attaches every typed block to a concept, so a concept has a sheet: its definition, the
    # results about it, what they mean, where it is used and where it goes wrong.
    #
    # A block belongs to the concepts named in its `about="id id"` attribute; without one it
    # belongs to the concept of the nearest definition above it in the same note. A proof
    # belongs to the statement above it. Blocks that attach to nothing are `loose`.
    #
    #   notes:    [{ "key", "title", "url", "course", "defines" => [{"id","name","anchor"}], "blocks" => [...] }]
    #   kinds:    id => kind hash from _data/knowledge.yml
    #   concepts: id => { "name", "note", "title", "url", "anchor", "planned" } from concept_index.rb
    # Returns { "concepts" => id => sheet, "loose" => [block], "order" => { course => [ids] } }.
    def model(notes, kinds, concepts)
      sheets = concepts.to_h do |id, c|
        [id, c.merge("definition" => nil, "extra_definitions" => [], "results" => [], "derivations" => [], "meaning" => [], "use" => [], "caution" => [],
                     "course" => nil, "needs" => [], "used_by" => [])]
      end
      loose = []
      notes.each do |note|
        defined = Array(note["defines"]).to_h { |d| [d["anchor"].to_s, d["id"].to_s] }
        current = nil
        last_statement = nil
        note["blocks"].each do |b|
          k = kinds[b["kind"]] or next
          entry = b.merge("label" => k["label"], "layer" => k["layer"], "note" => note["title"], "note_url" => note["url"],
                          "url" => "#{note['url']}##{b['id']}", "course" => note["course"], "proof" => nil)
          if b["kind"] == "proof"
            last_statement["proof"] = b["full"] if last_statement
            next
          end
          if defined[b["id"]] # the block a concept points at is its definition, whatever its kind
            current = defined[b["id"]]
            sheets[current] && sheets[current]["definition"] ||= entry
            last_statement = entry
            next
          end
          targets = b["about"].empty? ? [current].compact : b["about"]
          targets = targets.select { |t| sheets[t] }
          bucket = BUCKET[k["layer"]]
          if targets.empty? || bucket.nil?
            loose << entry if k["index"]
          else
            targets.each { |t| sheets[t][bucket] << entry }
          end
          last_statement = entry if k["layer"] == "claim"
        end
      end
      sheets.each_value { |c| c["gaps"] = gaps(c); c["slots"] = slots(c); c["score"] = c["slots"].values.count(true); c["missing"] = c["planned"] ? [] : SLOTS.reject { |k| c["slots"][k] } }
      { "concepts" => sheets, "loose" => loose }
    end

    # Which of the six slots a concept fills. A result is justified by a proof, a derivation
    # block, a citation in its text, or by being a law (taken from experiment, not derived).
    def slots(c)
      return SLOTS.to_h { |k| [k, false] } if c["planned"]

      # A concept may be introduced by a statement (a law, say): that block is its definition and its claim.
      stated = [c["definition"]].compact.select { |d| RESULT.include?(d["kind"]) }
      justified = c["derivations"].any? || (c["results"] + stated).any? { |r| r["proof"] || r["kind"] == "law" || r["full"].to_s.include?("cite ") }
      {
        "define" => !c["definition"].nil?,
        "claim" => c["results"].any? || stated.any?,
        "justify" => justified,
        "instance" => c["use"].any? { |u| INSTANCE.include?(u["kind"]) },
        "boundary" => c["caution"].any? { |u| u["kind"] == "trap" },
        "practice" => c["use"].any? { |u| PRACTICE.include?(u["kind"]) }
      }
    end

    # What a concept's sheet still lacks, most important first. Only written notes are judged.
    def gaps(c)
      return [] if c["planned"]

      g = []
      g << "definition" unless c["definition"]
      g << "result" if c["results"].empty?
      g << "example" if c["use"].empty?
      g
    end
  end

  if defined?(Jekyll::Generator)
    class KnowledgeGenerator < Jekyll::Generator
      safe true
      priority :lowest

      def generate(site)
        collection = site.collections["notes"]
        return if collection.nil?

        spec = site.data["knowledge"] || {}
        kinds = Array(spec["kinds"]).to_h { |k| [k["id"], k] }
        return if kinds.empty?

        courses = Array(site.data["courses"]).to_h { |c| [c["slug"], c] }
        course_of = {}
        Array(site.data["courses"]).each { |c| Array(c["parts"]).each { |pt| Array(pt["notes"]).each { |n| course_of[n] = c["slug"] } } }
        concept_used = Array(site.data["concept_list"]).to_h { |c| [c["id"], Array(c["used_by"]).size] }
        items = []
        per_note = {}
        model_notes = []
        collection.docs.each do |doc|
          next if doc.content.to_s.strip.empty?

          key = doc.relative_path.sub(%r{\A_notes/}, "").sub(/\.[^.\/]+\z/, "")
          content, found = Knowledge.scan(doc.content, kinds, key)
          doc.content = content
          counts = found.group_by { |b| b["kind"] }.transform_values(&:size)
          doc.data["statements"] = counts
          # What the "In this note" strip lists: the kinds that are statements (index: true).
          doc.data["statement_list"] = found.select { |b| kinds[b["kind"]]["index"] }.map do |b|
            k = kinds[b["kind"]]
            { "id" => b["id"], "kind" => b["kind"], "layer" => k["layer"], "label" => k["label"], "title" => b["title"] }
          end
          model_notes << { "key" => key, "title" => doc.data["title"].to_s, "url" => doc.url, "course" => course_of[key],
                           "defines" => Array(doc.data["defines"]).select { |d| d.is_a?(Hash) }, "blocks" => found }
          per_note[key] = { "counts" => counts, "defs" => found.select { |b| b["kind"] == "definition" && !b["title"].empty? }.map { |b| b["title"] } }
          slug = course_of[key] || key.split("/")[1].to_s
          defined = Array(doc.data["defines"]).to_h { |d| [d["anchor"].to_s, d["id"].to_s] if d.is_a?(Hash) }
          found.each_with_index do |b, i|
            next unless kinds[b["kind"]]["index"]

            cid = defined[b["id"]]
            items << b.merge("n" => i, "layer" => kinds[b["kind"]]["layer"], "note" => doc.data["title"].to_s, "url" => doc.url,
                             "course" => slug, "course_title" => (courses[slug] || {})["title"] || slug,
                             "domain" => (courses[slug] || {})["domain"].to_s,
                             "concept" => cid, "used" => cid ? concept_used[cid].to_i : 0)
          end
        end
        order = Array(site.data["courses"]).each_with_index.to_h { |c, i| [c["slug"], i] }
        items.sort_by! { |b| [order[b["course"]] || 999, b["url"], b["n"]] }
        site.data["knowledge_items"] = items

        # For the course pages: what each written note states, and per course totals.
        stats = Hash.new { |h, k| h[k] = Hash.new(0) }
        Array(site.data["courses"]).each do |course|
          Array(course["parts"]).each do |part|
            Array(part["items"]).each do |item|
              info = per_note[item["key"]] or next
              item["statements"] = info["counts"].select { |k, _| kinds[k]["index"] }
              item["statement_total"] = item["statements"].values.sum
              item["definitions"] = info["defs"]
              item["statements"].each { |k, n| stats[course["slug"]][k] += n }
            end
          end
        end
        Array(site.data["courses"]).each do |course|
          s = stats[course["slug"]]
          course["statement_counts"] = s.to_h
          course["statement_total"] = s.values.sum
        end

        build_concept_sheets(site, model_notes, kinds, course_of, concept_used)
      end

      private

      def build_concept_sheets(site, model_notes, kinds, course_of, concept_used)
        concepts = site.data["concepts"] || {}
        result = Knowledge.model(model_notes, kinds, concepts)
        sheets = result["concepts"]
        courses = Array(site.data["courses"]).to_h { |c| [c["slug"], c] }
        used_by = Array(site.data["concept_list"]).to_h { |c| [c["id"], c["used_by"]] }
        requires = model_notes.to_h { |n| [n["key"], n] }
        docs = site.collections["notes"].docs.to_h { |d| [d.relative_path.sub(%r{\A_notes/}, "").sub(/\.[^.\/]+\z/, ""), d] }

        sheets.each do |id, sh|
          sh["course"] = course_of[sh["note"]]
          sh["course_title"] = (courses[sh["course"]] || {})["title"].to_s
          sh["used_by"] = Array(used_by[id])
          sh["sheet_url"] = sh["planned"] ? nil : "/concepts/#{id}/"
          doc = docs[sh["note"]]
          sh["needs"] = doc ? Concepts.required_ids(doc.data).map { |r| concepts[r] }.compact.map { |r| { "id" => r["id"], "name" => r["name"], "url" => sheets[r["id"]] && sheets[r["id"]]["sheet_url"] } } : []
        end
        site.data["knowledge_concepts"] = sheets
        site.data["knowledge_loose"] = result["loose"]
        # Written concepts, most used first: the audit and study pages read this list.
        site.data["knowledge_concept_list"] = sheets.values.reject { |c| c["planned"] }.sort_by { |c| [-c["used_by"].size, c["name"].to_s.downcase] }

        # Per course: its concepts in reading order, and the statements that attach to none.
        Array(site.data["courses"]).each do |course|
          ids = []
          Array(course["parts"]).each do |part|
            Array(part["notes"]).each do |key|
              doc = docs[key] or next
              Concepts.defined_concepts(doc.data).each { |d| ids << d["id"] if sheets[d["id"]] }
            end
          end
          course["sheet_ids"] = ids
          course["sheet_loose"] = result["loose"].select { |b| b["course"] == course["slug"] }
          course["sheet_missing"] = ids.count { |i| sheets[i]["gaps"].include?("definition") }
        end

        sheets.each do |id, sh|
          next if sh["planned"] || sh["url"].nil?

          page = Jekyll::PageWithoutAFile.new(site, site.source, File.join("concepts", id), "index.html")
          page.content = ""
          page.data.merge!("layout" => "concept", "title" => sh["name"], "classes" => "wide concept-page", "author_profile" => false,
                           "breadcrumbs" => false, "concept_id" => id, "toc" => false, "sitemap" => true,
                           "description" => "Definition, results, examples and pitfalls for #{sh['name']}.",
                           "last_modified_at" => site.time)
          site.pages << page
        end
      end
    end
  end
end
