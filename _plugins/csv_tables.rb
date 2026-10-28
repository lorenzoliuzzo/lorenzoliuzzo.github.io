require "csv"
require "pathname"

# Parses the CSVs that notes render as tables, once at build time, and hands them
# to _includes/table.html through site.data["csv"].
#
# The include used to fetch each file in the browser and split it on commas. That
# dropped any reader without JavaScript — and every crawler — on "Loading table...",
# and it mis-parsed the one thing CSV quoting exists for: a cell containing a comma
# came out as two cells, silently shifting every column after it. Ruby's CSV
# handles the quoting; doing it here also means a broken file fails the build
# instead of one page.
module MyThingsLab
  class CsvTables < Jekyll::Generator
    safe true
    priority :high

    def generate(site)
      source = Pathname.new(site.source)

      site.data["csv"] = Dir
        .glob(File.join(site.source, "assets", "**", "*.csv"))
        .sort
        .each_with_object({}) do |path, tables|
          # Keyed by the same site-absolute path the note writes in `url=`, so the
          # include can look a table up with no massaging.
          key = "/" + Pathname.new(path).relative_path_from(source).to_s
          tables[key] = read(path, key)
        end
    end

    private

    def read(path, key)
      CSV.read(path).reject { |row| row.compact.all? { |cell| cell.strip.empty? } }
    rescue CSV::MalformedCSVError => e
      raise Jekyll::Errors::FatalException, "#{key}: #{e.message}"
    end
  end
end
