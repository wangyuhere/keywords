class WordPresenter
  attr_reader :word

  delegate :name, :occurrences_count, :articles_count, to: :word

  def initialize(word)
    @word = word
  end

  def occurrences_per_article
    return 0 if articles_count == 0
    (occurrences_count.to_f / articles_count).round 2
  end
end
