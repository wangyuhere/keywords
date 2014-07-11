module Analyze
  module PhrasesKey
    def count_key
      @count_key ||= "count_phrases_#{gram}"
    end

    def count_word_key
      "count_phrases_1"
    end

    def rank_key
      @rank_key ||= "rank_phrases_#{gram}"
    end
  end
end
