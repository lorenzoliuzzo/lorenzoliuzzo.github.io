# Citations. One bibliography (_data/papers.yml), cited from the text with
#
#   {% cite demsar-2006 %}              ->  [1]
#   {% cite demsar-2006 p=12 %}         ->  [1, p. 12]
#   {% cite hopfield-1982 egnn %}       ->  [2, 3]
#   {% citet demsar-2006 %}             ->  Demšar (2006) [1]
#
# Numbers follow first appearance in the note, so the in-text numbers and the reference list
# at the end of the note (_includes/references.html, added by the note layout) always agree.
# Everything is rendered at build time: it works without JavaScript and the cited works are
# visible to the build, which is what lets /references/ say which notes cite each work.
#
# Front matter may also list `cites: [id, ...]`. Those that the text never cites appear
# under "Further reading" instead of in the numbered list. So do the works a note's
# `context.timeline` entries point at with `cite: id` (see _includes/note-context.html).
#
# What this sets (see Generator below):
#   doc.data["cited"]            ordered paper hashes the text cites, each with "n" (its number)
#   doc.data["cite_numbers"]     id => n, read by the tags while the note is rendered
#   doc.data["further_reading"]  papers listed in `cites` but not cited in the text
#   site.data["paper_by_id"]     id => paper, each with "short" ("Hopfield (1982)") for links
#   site.data["citation_index"]  id => [{title, url}] of the notes that cite the work
#
# Unknown ids are warnings here; tools/check_notes.rb turns them into errors.
module MyThingsLab
  module Citations
    module_function

    # Matches a whole tag in raw source, so the order can be worked out before rendering.
    TAG = /\{%-?\s*cite[t]?\s+(.*?)\s*-?%\}/m

    # "a b p=12" or "a, b" -> [["a", "b"], {"p" => "12"}]
    def parse(markup)
      keys = []
      opts = {}
      markup.to_s.split(/[\s,]+/).reject(&:empty?).each do |token|
        if (m = token.match(/\A(\w+)=(.+)\z/))
          opts[m[1]] = m[2].delete("\"'")
        else
          keys << token.downcase
        end
      end
      [keys, opts]
    end

    # Ids in order of first appearance in a note's source.
    def ordered_keys(source)
      seen = []
      source.to_s.scan(TAG).flatten.each do |markup|
        parse(markup).first.each { |key| seen << key unless seen.include?(key) }
      end
      seen
    end

    def surname(author)
      author.to_s.split.last.to_s
    end

    # "Demšar", "Hinton and Sejnowski", "Vaswani et al."
    def short_authors(authors)
      list = authors.to_s.split(/,\s*|\s+and\s+/).map(&:strip).reject { |a| a.empty? || a == "et al." || a == "et al" }
      return "Unknown" if list.empty?
      return surname(list[0]) + " et al." if list.size > 2 || authors.to_s.include?("et al")
      return surname(list[0]) if list.size == 1

      "#{surname(list[0])} and #{surname(list[1])}"
    end

    def title_text(paper)
      "#{paper['authors']} (#{paper['year']}). #{paper['title']}."
    end

    def escape(text)
      text.to_s.gsub("&", "&amp;").gsub("<", "&lt;").gsub(">", "&gt;").gsub('"', "&quot;")
    end

    def link(paper, number, text)
      %(<a class="cite-link" href="#ref-#{paper['id']}" title="#{escape(title_text(paper))}">#{text || number}</a>)
    end

    def render(tag, keys, opts, papers, numbers)
      cells = keys.map do |key|
        paper = papers[key]
        n = numbers[key]
        next %(<span class="cite-missing">#{escape(key)}?</span>) if paper.nil? || n.nil?

        link(paper, n, nil)
      end
      cells << "p. #{escape(opts['p'])}" if opts["p"]
      cells << "pp. #{escape(opts['pp'])}" if opts["pp"]
      numeric = %(<span class="cite">[#{cells.join(', ')}]</span>)
      return numeric unless tag == "citet"

      first = papers[keys.first]
      return numeric if first.nil? || numbers[keys.first].nil?

      %(<span class="cite cite--text">#{link(first, numbers[keys.first], "#{escape(short_authors(first['authors']))} (#{first['year']})")}) +
        %( [#{cells.join(', ')}]</span>)
    end

    # The `cite:` ids of a note's context timeline, in order.
    def timeline_cites(context)
      return [] unless context.is_a?(Hash)

      Array(context["timeline"]).map { |e| e.is_a?(Hash) ? e["cite"].to_s : "" }.reject(&:empty?)
    end

    # Pure function behind the generator, so tools and tests can reuse it.
    # source: the raw body; cites: the `cites` front matter. Returns
    # [cited (ordered paper hashes with "n"), numbers (id => n), further (paper hashes), unknown (ids)].
    def resolve(source, cites, papers)
      keys = ordered_keys(source)
      unknown = keys.reject { |k| papers.key?(k) }
      known = keys.select { |k| papers.key?(k) }
      numbers = {}
      cited = known.each_with_index.map do |key, i|
        numbers[key] = i + 1
        papers[key].merge("n" => i + 1)
      end
      further_ids = Array(cites).map { |c| c.to_s.downcase }.uniq.reject { |k| numbers.key?(k) }
      unknown += further_ids.reject { |k| papers.key?(k) }
      further = further_ids.select { |k| papers.key?(k) }.map { |k| papers[k] }
      [cited, numbers, further, unknown.uniq]
    end
  end

  class CiteTag < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      super
      @tag = tag_name.to_s
      @keys, @opts = Citations.parse(markup)
    end

    def render(context)
      page = context.registers[:page] || {}
      numbers = page["cite_numbers"] || {}
      papers = context.registers[:site].data["paper_by_id"] || {}
      Citations.render(@tag, @keys, @opts, papers, numbers)
    end
  end

  Liquid::Template.register_tag("cite", CiteTag)
  Liquid::Template.register_tag("citet", CiteTag)

  if defined?(Jekyll::Generator)
    class CitationGenerator < Jekyll::Generator
      safe true
      # After the planned-note split (:high), alongside ConceptIndexGenerator.
      priority :normal

      COLLECTIONS = %w[notes threads library projects travel].freeze

      def generate(site)
        papers = {}
        Array(site.data["papers"]).each do |paper|
          next unless paper.is_a?(Hash) && paper["id"]

          paper["short"] = "#{Citations.short_authors(paper['authors'])} (#{paper['year']})"
          paper["title_text"] = Citations.title_text(paper)
          papers[paper["id"].to_s] = paper
        end
        site.data["paper_by_id"] = papers

        index = Hash.new { |h, k| h[k] = [] }
        COLLECTIONS.each do |name|
          collection = site.collections[name] or next
          collection.docs.each do |doc|
            cited, numbers, further, unknown = Citations.resolve(doc.content, Array(doc.data["cites"]) + Citations.timeline_cites(doc.data["context"]), papers)
            unknown.each { |id| Jekyll.logger.warn "Citations:", "#{doc.relative_path} cites unknown work #{id} (add it to _data/papers.yml)" }
            doc.data["cited"] = cited
            doc.data["cite_numbers"] = numbers
            doc.data["further_reading"] = further
            (cited + further).each do |paper|
              index[paper["id"]] << { "title" => doc.data["title"], "url" => doc.url, "collection" => name }
            end
          end
        end
        site.data["citation_index"] = index
      end
    end
  end
end
