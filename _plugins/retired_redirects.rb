# Keeps previously-published URLs alive after their note was retired to the
# planned state. GitHub Pages serves static files only, so there is no server to
# issue a 301 — the standard static answer is a meta refresh plus a canonical
# link, which is what jekyll-redirect-from generates. Doing it here instead
# avoids adding a gem for ~40 lines of output.
#
# The map lives in _data/retired_urls.yml rather than in `redirect_from:` keys on
# the notes, because a retired note no longer renders: the page carrying the key
# would never be built. The data file is also the honest shape for what this is —
# a record of addresses the site once answered on.
module MyThingsLab
  class RedirectPage < Jekyll::PageWithoutAFile
    # target   — where a reader goes, anchored at the relevant archive section.
    # canonical— absolute and fragment-free, because a canonical URL with a
    #            fragment is normalized away by search engines anyway. No
    #            `noindex` alongside it: that would tell a crawler to ignore the
    #            page, discarding the very consolidation signal the canonical is
    #            there to send.
    def initialize(site, from, target, canonical)
      super(site, site.source, File.dirname(from), File.basename(from))
      data["layout"] = nil
      data["sitemap"] = false
      self.content = render(target, canonical)
    end

    private

    def escape(url)
      url.gsub("&", "&amp;").gsub('"', "&quot;").gsub("<", "&lt;")
    end

    def render(target, canonical)
      href = escape(target)
      <<~HTML
        <!DOCTYPE html>
        <html lang="en">
        <head>
        <meta charset="utf-8">
        <meta http-equiv="refresh" content="0; url=#{href}">
        <link rel="canonical" href="#{escape(canonical)}">
        <title>Redirecting&hellip;</title>
        </head>
        <body>
        <p>This note has not been written yet. Redirecting to
        <a href="#{href}">the notes archive</a>.</p>
        </body>
        </html>
      HTML
    end
  end

  if defined?(Jekyll::Generator)
    class RetiredRedirectsGenerator < Jekyll::Generator
      safe true
      priority :low

      def generate(site)
        Array(site.data["retired_urls"]).each do |entry|
          from = entry["from"].to_s
          to = entry["to"].to_s
          next if from.empty? || to.empty?

          # A directory URL needs an index.html behind it; a bare .html path is
          # already the file to write.
          path = from.end_with?("/") ? File.join(from, "index.html") : from
          target = File.join(site.baseurl.to_s, to)
          canonical = "#{site.config["url"]}#{File.join(site.baseurl.to_s, to.sub(/#.*\z/, ""))}"

          site.pages << RedirectPage.new(site, path.sub(%r{\A/}, ""), target, canonical)
        end
      end
    end
  end
end
