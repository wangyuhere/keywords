class TrendsPresenter
  attr_reader :word, :data

  def initialize(word_id)
    @word_id = word_id
  end

  def has_word?
    @word_id.present?
  end

  def word
    @word ||= Word.find @word_id
  end

  def data
    @data ||= occurrences_count_last_30_days
  end

  private

  def occurrences_count_last_30_days
    range = (30.days.ago)..Date.yesterday
    word.occurrences.joins(:article).group("date(articles.published_at)").where("articles.published_at #{range.to_s(:db)}").order('date(articles.published_at)').count
  end
end
