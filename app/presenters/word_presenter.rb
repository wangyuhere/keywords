class WordPresenter
  attr_reader :word

  delegate :name, :occurrences_count, :articles_count, to: :word

  ARTICLES_PER_PAGE = 15

  def initialize(word, page=1)
    @word = word
    @page = page.to_i
  end

  def occurrences_per_article
    return 0 if articles_count == 0
    (occurrences_count.to_f / articles_count).round 2
  end

  def articles
    @articles ||= articles_with_pagination
  end

  private

  def articles_with_pagination
    ids = Occurrence.select(:article_id).where(word_id: word.id).uniq.order('article_id desc').page(@page).per(ARTICLES_PER_PAGE).map &:article_id
    Kaminari.paginate_array(Article.where(id: ids).order('published_at desc').to_a, total_count: articles_count).page(@page).per(ARTICLES_PER_PAGE)
  end
end
