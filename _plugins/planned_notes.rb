# A note whose body is empty is an outline placeholder — a topic that has been
# planned but not written. Published as-is it becomes a fully-chromed URL with
# nothing on it, and Jekyll copies the ones that lack front matter into the site
# verbatim, serving raw markdown at /notes/<path>.md.
#
# Planned notes are therefore pulled out of the collection before rendering, so
# no page is generated, and handed to the archive through site.data so the
# outline stays visible without being clickable.
#
# The state is derived from the body rather than read from a `status:` key for
# the same reason note_verification.rb hashes the content: a hand-written flag
# keeps asserting yesterday's truth. Give a note prose and it starts publishing;
# empty it and the page retires itself.
module MyThingsLab
  module PlannedNotes
    module_function

    def planned?(doc)
      doc.content.to_s.strip.empty?
    end

    def summarize(doc)
      {
        "title" => doc.data["title"].to_s.empty? ? File.basename(doc.relative_path, ".*") : doc.data["title"],
        "tags" => Array(doc.data["tags"]),
        "path" => doc.relative_path,
      }
    end
  end

  if defined?(Jekyll::Generator)
    class PlannedNotesGenerator < Jekyll::Generator
      safe true
      priority :high

      def generate(site)
        collection = site.collections["notes"]
        return if collection.nil?

        # Generators run before rendering, so doc.content is still the raw body.
        planned, publishable = collection.docs.partition { |doc| PlannedNotes.planned?(doc) }
        collection.docs.replace(publishable)

        site.data["planned_notes"] =
          planned.map { |doc| PlannedNotes.summarize(doc) }.sort_by { |entry| entry["title"].to_s.downcase }
      end
    end
  end
end
