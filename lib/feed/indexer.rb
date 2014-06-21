module Feed
  class Indexer
    attr_reader :text, :tokens

    def initialize(text)
      @text = text
    end

    def tokens
      @tokens ||= text.split(/[^\p{L}]+/).reject(&:empty?).map(&:downcase)
    end
  end
end
