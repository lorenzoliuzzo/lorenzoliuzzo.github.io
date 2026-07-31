require "digest"

# Computes, at build time, whether a note's "human-verified" claim still matches the
# note's current content. A plain boolean would keep asserting review after the text
# was edited; hashing the body means the claim expires by itself.
module MyThingsLab
  module Verification
    module_function

    # Must stay byte-for-byte identical to normalizeBody() in tools/mythingslab/core.mjs.
    # Covered by the cross-language test in tools/mythingslab/core.test.mjs.
    def normalize(text)
      text.to_s
          .dup
          .force_encoding(Encoding::UTF_8)
          .sub(/\A\uFEFF/, "")
          .gsub(/\r\n?/, "\n")
          .split("\n", -1)
          .map { |line| line.sub(/[ \t]+\z/, "") }
          .join("\n")
          .sub(/\A\n+/, "")
          .sub(/\n+\z/, "")
    end

    def digest(text)
      "sha256:" + Digest::SHA256.hexdigest(normalize(text))
    end

    def state_for(data, content)
      return "unverified" unless truthy?(data["human_verified"])

      stored = data["verified_hash"].to_s.strip
      return "unlocked" if stored.empty?

      digest(content) == stored ? "verified" : "stale"
    end

    def truthy?(value)
      value == true || value.to_s.strip.downcase == "true"
    end
  end

  # Guarded so the module above can be required outside Jekyll by the
  # cross-language hash test.
  if defined?(Jekyll::Generator)
    class NoteVerificationGenerator < Jekyll::Generator
      safe true
      priority :high

      def generate(site)
        site.collections.each_value do |collection|
          collection.docs.each do |doc|
            # Generators run before rendering, so doc.content is still raw markdown.
            doc.data["content_hash"] = Verification.digest(doc.content)
            doc.data["verification_state"] = Verification.state_for(doc.data, doc.content)
          end
        end
      end
    end
  end
end
