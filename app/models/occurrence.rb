class Occurrence < ActiveRecord::Base
  belongs_to :word, counter_cache: true
  belongs_to :article
  belongs_to :source

  before_create :set_source

  def self.massive_insert_by_article(article, word_ids)
    values = word_ids.map { |word_id| "(#{word_id},#{article.id},#{article.source_id})" }
    Occurrence.connection.execute "INSERT INTO occurrences (word_id, article_id, source_id) VALUES #{values.join(',')}"
    word_ids.group_by(&:to_i).map{|k,v|[k,v.length]}.group_by(&:last).each do |count, ids|
      Word.update_counters ids.map(&:first), occurrences_count: count
    end
  end

  protected

  def set_source
    self.source_id = article.source_id
  end
end
