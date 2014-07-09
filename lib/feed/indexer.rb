module Feed
  class Indexer

    attr_reader :text, :tokens

    def initialize(text)
      @text = text
    end

    def tokens
      @tokens ||= text.split(/[^\p{L}]+/).reject{|w| w.length < 2}.map(&:downcase)
    end

    def phrases(gram=2)
      sub_sentences.map do |s|
        words = s.split(/[^\p{L}]+/).map(&:downcase)
        next if words.length < gram
        (0..(words.length - gram)).map { |i| gram.times.map { |n| words[n+i] }.join(' ') }
      end.compact.flatten
    end

    private

    def sub_sentences
      text.split /[.,;:?!]+\s+/
    end
  end
end
