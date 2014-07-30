require 'feed/indexer'

class ArticleIndexer
  attr_reader :article

  def initialize(article)
    @article = article
  end

  def index!
    Article.transaction do
      delete_all_occurrences
      tokens = indexer.tokens
      if tokens.present?
        word_ids = Word.find_or_create_ids tokens
        Occurrence.massive_insert_by_article(article, word_ids)
        update_counters
      end
      article.indexed_at = Time.now
      article.save!
      article
    end
  end

  private

  def indexer
    @indexer ||= Feed::Indexer.new article.text
  end

  def delete_all_occurrences
    update_counters false
    Occurrence.where(article_id: article.id).delete_all
  end

  def update_counters(is_added = true)
    word_ids = article.occurrences.reload.map { |o| o.word_id }
    return if word_ids.empty?

    op = is_added ? 1 : -1
    group_by_count(word_ids).each do |count, ids|
      Word.update_counters ids.map(&:first), occurrences_count: count*op
    end
    Word.update_counters word_ids.uniq, articles_count: 1*op
  end

  def group_by_count(ids)
    ids.group_by(&:to_i).map{|k,v|[k,v.length]}.group_by(&:last)
  end
end
