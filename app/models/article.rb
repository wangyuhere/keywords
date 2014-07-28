require 'feed/parser'
require 'feed/indexer'

class Article < ActiveRecord::Base
  attr_reader :text

  belongs_to :source

  has_many :occurrences, dependent: :delete_all
  has_many :words, through: :occurrences

  scope :newly, -> { where(body: nil) }
  scope :ready_to_index, -> { where("indexed_at is NULL AND body is not NULL AND body != ''") }
  scope :indexed, -> { where("indexed_at is NOT NULL") }

  delegate :name, to: :source, prefix: 'source'

  def text
    "#{title}: #{body}"
  end

  def parse!
    self.body = parser.text
    save!
    self
  end

  def index!
    transaction do
      delete_all_occurrences
      word_ids = Word.find_or_create_ids(indexer.tokens)
      Occurrence.massive_insert_by_article(self, word_ids)
      update_counters
      self.indexed_at = Time.now
      save!
      self
    end
  end

  def parser
    @parser ||= Feed::Parser.new(url, source.css_selector)
  end

  def indexer
    @indexer ||= Feed::Indexer.new(text)
  end

  def to_s
    "<Article id:#{id}, url:#{url}>"
  end

  private

  def delete_all_occurrences
    update_counters false
    Occurrence.where(article_id: id).delete_all
  end

  def update_counters(is_added = true)
    word_ids = occurrences.reload.map { |o| o.word_id }
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
