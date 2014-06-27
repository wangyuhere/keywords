require 'feed/parser'
require 'feed/indexer'

class Article < ActiveRecord::Base
  attr_reader :text

  belongs_to :source

  has_many :occurrences, dependent: :delete_all
  has_many :words, through: :occurrences

  scope :empty, -> { where(body: '') }
  scope :newly, -> { where(body: nil) }
  scope :ready_to_index, -> { where("indexed_at is NULL AND body is not NULL AND body != ''") }

  def text
    "#{title} #{body}"
  end

  def parse!
    self.body = parser.text
    save!
    self
  end

  def index!
    transaction do
      Occurrence.where(article_id: id).delete_all
      word_ids = Word.find_or_create_ids(indexer.tokens)
      Occurrence.massive_insert_by_article(self, word_ids)
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
end
