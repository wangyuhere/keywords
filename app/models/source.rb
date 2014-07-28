require 'feed/fetcher'

class Source < ActiveRecord::Base
  attr_accessor :fetcher

  has_many :articles, dependent: :delete_all
  has_many :occurrences, dependent: :delete_all
  has_many :words, through: :occurrences

  def self.from_feed(feed_url)
    raise 'feed url can not be empty' unless feed_url.present?
    source = where(feed_url: feed_url).first_or_initialize
    source.fetcher = Feed::Fetcher.new feed_url
    source.update_feed!
  end

  def name
    title[/\w+/]
  end

  def fetch!
    count = 0
    return count if feed_url.nil?
    return count unless fetcher.is_modified_since?(last_modified_at)
    transaction do
      fetcher.new_entries_since(last_modified_at).each do |e|
        articles.where(url: e.url).first_or_create(title: e.title, published_at: e.published)
        count += 1
      end
      self.last_modified_at = fetcher.last_modified_at
      save!
    end
    count
  end

  def fetcher
    @fetcher ||= Feed::Fetcher.new feed_url
  end

  def update_feed!
    self.title = fetcher.title.strip
    self.url = fetcher.url.strip
    save!
    self
  end
end
