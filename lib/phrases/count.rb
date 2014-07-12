require 'phrases/key'

module Phrases
  class Count
    include ::WithRedis, Key

    attr_reader :text, :gram

    def initialize(text, gram=2)
      @text = text
      @gram = gram
    end

    def run
      phrases_count.each { |phrase, count| redis.zincrby count_key, count, phrase }
    end

    def to_a
      @all_phrases ||= sub_sentences.map { |sentence| phrases_from sentence }.compact.flatten
    end

    private

    def phrases_count
      to_a.inject(Hash.new(0)) { |h, e| h[e] += 1 ; h }
    end

    def sub_sentences
      text.split /[.,;:?!]+\s+/
    end

    def phrases_from(sentence)
      words = sentence.split(/[^\p{L}]+/).reject(&:empty?).map(&:downcase)
      return if words.length < gram
      phrases_by_gram words
    end

    def phrases_by_gram(words)
      (0..(words.length - gram)).map { |i| gram.times.map { |n| words[n+i] }.join(' ') }
    end
  end
end
