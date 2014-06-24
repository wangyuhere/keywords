module Feed
  class Indexer
    attr_reader :text, :tokens

    def initialize(text)
      @text = text
    end

    def tokens
      @tokens ||= text.split(/[^\p{L}]+/).reject{|w| w.length < 2}.map(&:downcase)
    end
  end
end
