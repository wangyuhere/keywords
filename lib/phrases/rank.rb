require 'phrases/key'

module Phrases
  class Rank
    include ::WithRedis, Key

    MIN_PHRASES_COUNT = 10

    attr_reader :gram

    def initialize(gram=2)
      @gram = gram
      @words = {}
    end

    def run
      data = redis.zrevrangebyscore count_key, '+inf', MIN_PHRASES_COUNT, with_scores: true
      data.each { |phrase, count| rank_phrase(phrase, count) }
    end

    private

    def rank_phrase(phrase, count)
      words = phrase.split /\s+/
      total = words.map { |w| word_count(w) }.sum - (gram-1)*count
      redis.zadd rank_key, count / total, phrase
    end

    def word_count(word)
      if @words.has_key? word
        @words[word]
      else
        @words[word] = redis.zscore count_word_key, word
      end
    end

  end
end
