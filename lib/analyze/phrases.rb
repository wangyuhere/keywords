module Analyze
  class Phrases

    attr_reader :text, :gram

    def initialize(text, gram=2)
      @text = text
      @gram = gram
    end

    def calculate!
      to_a.each { |p| Redis.current.zincrby key, 1, p }
    end

    def to_a
      @all_phrases = sub_sentences.map do |s|
        words = s.split(/[^\p{L}]+/).reject(&:empty?).map(&:downcase)
        next if words.length < gram
        (0..(words.length - gram)).map { |i| gram.times.map { |n| words[n+i] }.join(' ') }
      end.compact.flatten
    end

    private

    def key
      "count_phrases_#{gram}"
    end

    def sub_sentences
      text.split /[.,;:?!]+\s+/
    end
  end
end
