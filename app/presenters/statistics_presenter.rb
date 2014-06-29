class StatisticsPresenter
  include ActionView::Helpers::NumberHelper

  def uniq_words_count
    @uniq_words_count ||= number_with_delimiter(Word.count)
  end

  def articles_count
    @articles_count ||= number_with_delimiter(Article.count)
  end

  def total_words_count
    @total_words_count ||= number_with_delimiter(Occurrence.count)
  end
end
