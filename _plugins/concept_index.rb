# Notes declare the concepts they introduce (`defines`) and the ones they lean on
# (`requires`) in front matter. This plugin turns that into three things:
#
#   site.data["concepts"]   id => {name, note, title, url, anchor, planned}
#   doc.data["summary"]     the front-matter `excerpt`, readable from Liquid as `doc.summary`
#   doc.data["needs"]       the prerequisites of a note grouped by the note that
#                           introduced them, ready for _includes/note-head.html
#   /graph.json             the whole thing as nodes and edges, for a knowledge graph
#
# Front matter, per note:
#
#   defines:                       # concepts this note introduces
#     - id: bayes-theorem          # global, lower-case, hyphenated; unique across the site
#       name: "Bayes' theorem"
#       anchor: total-probability-and-bayes   # heading id inside this note
#   requires:                      # ids of concepts defined in earlier notes
#     - bayes-theorem
#
# A stub (empty body) may already declare `defines`, so a later note can require a
# concept before its note is written; the link then renders as plain text until the
# page exists. Mistakes are reported as warnings here, and tools/check_notes.rb turns
# the same mistakes into a failing check.
require "json"

module MyThingsLab
  module Concepts
    module_function

    def note_key(relative_path)
      relative_path.to_s.sub(%r{\A_notes/}, "").sub(/\.[^.\/]+\z/, "")
    end

    def defined_concepts(data)
      Array(data["defines"]).map do |entry|
        next unless entry.is_a?(Hash) && entry["id"]

        { "id" => entry["id"].to_s, "name" => (entry["name"] || entry["id"]).to_s, "anchor" => entry["anchor"].to_s }
      end.compact
    end

    def required_ids(data)
      Array(data["requires"]).map { |entry| entry.is_a?(Hash) ? entry["concept"].to_s : entry.to_s }.reject(&:empty?)
    end
  end

  if defined?(Jekyll::Generator)
    class ConceptIndexGenerator < Jekyll::Generator
      safe true
      # After PlannedNotesGenerator (:high) has split the stubs off the collection.
      priority :normal

      def generate(site)
        collection = site.collections["notes"]
        return if collection.nil?

        concepts = index(site, collection.docs)
        site.data["concepts"] = concepts

        collection.docs.each do |doc|
          doc.data["needs"] = needs_for(doc, concepts)
          # Liquid's `doc.excerpt` is generated from the body and ignores the front-matter
          # sentence, so the Next-step card reads this copy instead.
          doc.data["summary"] = doc.data["excerpt"].to_s
        end

        page = Jekyll::PageWithoutAFile.new(site, site.source, "", "graph.json")
        page.content = JSON.pretty_generate(graph(site, collection.docs, concepts)) + "\n"
        page.data["layout"] = nil
        page.data["render_with_liquid"] = false
        page.data["sitemap"] = false
        site.pages << page
      end

      private

      def index(site, docs)
        concepts = {}
        add = lambda do |entry, key, title, url, planned|
          if concepts.key?(entry["id"])
            Jekyll.logger.warn "Concepts:", "#{entry['id']} is defined by both #{concepts[entry['id']]['note']} and #{key}"
            next
          end
          concepts[entry["id"]] = {
            "id" => entry["id"], "name" => entry["name"], "note" => key, "title" => title,
            "url" => url, "anchor" => entry["anchor"], "planned" => planned
          }
        end

        docs.each do |doc|
          Concepts.defined_concepts(doc.data).each do |entry|
            add.call(entry, Concepts.note_key(doc.relative_path), doc.data["title"], doc.url, false)
          end
        end
        Array(site.data["planned_notes"]).each do |stub|
          Array(stub["defines"]).each do |raw|
            entry = Concepts.defined_concepts("defines" => [raw]).first or next
            add.call(entry, Concepts.note_key(stub["path"]), stub["title"], nil, true)
          end
        end
        concepts
      end

      def needs_for(doc, concepts)
        own = Concepts.note_key(doc.relative_path)
        groups = {}
        Concepts.required_ids(doc.data).each do |id|
          concept = concepts[id]
          if concept.nil?
            Jekyll.logger.warn "Concepts:", "#{doc.relative_path} requires unknown concept #{id}"
            next
          end
          next if concept["note"] == own

          group = (groups[concept["note"]] ||= { "title" => concept["title"], "url" => concept["url"], "items" => [] })
          href = concept["url"] && (concept["anchor"].empty? ? concept["url"] : "#{concept['url']}##{concept['anchor']}")
          group["items"] << { "name" => concept["name"], "href" => href }
        end
        groups.values
      end

      # Nodes: domain, course, part, note (written or planned), concept. Edges: contains
      # (domain > course > part > note), next (reading order), defines, requires.
      def graph(site, docs, concepts)
        nodes = []
        edges = []
        by_key = docs.each_with_object({}) { |doc, h| h[Concepts.note_key(doc.relative_path)] = doc }
        stubs = Array(site.data["planned_notes"]).each_with_object({}) { |s, h| h[Concepts.note_key(s["path"])] = s }

        Array(site.data["domains"]).each do |domain|
          nodes << { "id" => "domain:#{domain['id']}", "type" => "domain", "title" => domain["title"] }
        end
        Array(site.data["courses"]).each do |course|
          cid = "course:#{course['slug'] || Jekyll::Utils.slugify(course['title'])}"
          nodes << { "id" => cid, "type" => "course", "title" => course["title"], "summary" => course["summary"],
                     "domain" => course["domain"], "url" => course["url"] }
          edges << { "from" => "domain:#{course['domain']}", "to" => cid, "type" => "contains" } if course["domain"]
          previous = nil
          Array(course["parts"]).each_with_index do |part, pi|
            pid = "#{cid}/part:#{Jekyll::Utils.slugify(part['title'])}"
            nodes << { "id" => pid, "type" => "part", "title" => part["title"], "order" => pi + 1 }
            edges << { "from" => cid, "to" => pid, "type" => "contains" }
            Array(part["notes"]).each do |key|
              nid = "note:#{key}"
              if (doc = by_key[key])
                nodes << { "id" => nid, "type" => "note", "status" => "written", "title" => doc.data["title"],
                           "url" => doc.url, "summary" => doc.data["excerpt"], "hook" => doc.data["hook"],
                           "tags" => Array(doc.data["tags"]) }
              else
                nodes << { "id" => nid, "type" => "note", "status" => "planned",
                           "title" => stubs.dig(key, "title") || key }
              end
              edges << { "from" => pid, "to" => nid, "type" => "contains" }
              edges << { "from" => previous, "to" => nid, "type" => "next" } if previous
              previous = nid
            end
          end
        end

        concepts.each_value do |c|
          nodes << { "id" => "concept:#{c['id']}", "type" => "concept", "name" => c["name"],
                     "status" => c["planned"] ? "planned" : "written",
                     "url" => c["url"] && (c["anchor"].empty? ? c["url"] : "#{c['url']}##{c['anchor']}") }
          edges << { "from" => "note:#{c['note']}", "to" => "concept:#{c['id']}", "type" => "defines" }
        end
        docs.each do |doc|
          Concepts.required_ids(doc.data).each do |id|
            next unless concepts.key?(id)

            edges << { "from" => "note:#{Concepts.note_key(doc.relative_path)}", "to" => "concept:#{id}", "type" => "requires" }
          end
        end

        { "version" => 1, "nodes" => nodes, "edges" => edges }
      end
    end
  end
end
