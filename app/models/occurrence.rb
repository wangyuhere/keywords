class Occurrence < ActiveRecord::Base
  belongs_to :word, counter_cache: true
  belongs_to :article
  belongs_to :source

  before_create :set_source

  def self.massive_insert_by_article(article, word_ids)
    values = word_ids.map { |word_id| "(#{word_id},#{article.id},#{article.source_id})" }
    Occurrence.connection.execute "INSERT INTO occurrences (word_id, article_id, source_id) VALUES #{values.join(',')}"
    update_counters article, word_ids
  end

  protected

  def set_source
    self.source_id = article.source_id
  end

  private

  def self.update_counters(article, word_ids)
    group_by_count(word_ids).each do |count, ids|
      Word.update_counters ids.map(&:first), occurrences_count: count
    end
    Word.update_counters word_ids.uniq, articles_count: 1
  end

  def self.group_by_count(ids)
    ids.group_by(&:to_i).map{|k,v|[k,v.length]}.group_by(&:last)
  end
end
