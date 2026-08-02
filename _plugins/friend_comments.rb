# Validates _data/friends.yml at build time. The 140-character limit is what keeps
# the section a wall of one-liners rather than a guestbook, and the form on /about/
# can only enforce it in the browser — this is the half that cannot be bypassed.
module MyThingsLab
  class FriendCommentsValidator < Jekyll::Generator
    safe true
    priority :high

    MAX_LENGTH = 140

    def generate(site)
      entries = site.data.dig("friends", "comments")
      return if entries.nil?

      unless entries.is_a?(Array)
        raise Jekyll::Errors::FatalException,
              "_data/friends.yml: `comments` must be a list, got #{entries.class}."
      end

      errors = entries.each_with_index.flat_map { |entry, index| errors_for(entry, index) }
      return if errors.empty?

      raise Jekyll::Errors::FatalException, "_data/friends.yml:\n  " + errors.join("\n  ")
    end

    private

    def errors_for(entry, index)
      label = "entry #{index + 1}"
      return ["#{label}: expected a mapping, got #{entry.class}."] unless entry.is_a?(Hash)

      errors = []
      errors << "#{label}: `name` is required." if blank?(entry["name"])

      comment = entry["comment"].to_s.strip
      if comment.empty?
        errors << "#{label}: `comment` is required."
      elsif comment.length > MAX_LENGTH
        errors << "#{label} (#{entry["name"]}): comment is #{comment.length} characters, " \
                  "#{MAX_LENGTH} is the maximum."
      end

      errors
    end

    def blank?(value)
      value.to_s.strip.empty?
    end
  end
end
