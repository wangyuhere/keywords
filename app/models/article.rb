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

  def to_s
    "<Article id:#{id}, url:#{url}>"
  end
end
