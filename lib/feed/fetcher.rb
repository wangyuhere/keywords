require 'feedjira'

module Feed
  class Fetcher
    attr_reader :title, :feed_url, :url, :entries, :last_modified_at

    def initialize(feed_url)
      @feed_url = feed_url
      @feed = Feedjira::Feed.fetch_and_parse @feed_url
      @last_modified_at = @feed.last_modified
    end

    def url
      @feed.url
    end

    def title
      @feed.title
    end

    def entries
      @feed.entries
    end

    def is_modified_since?(time)
      time.nil? || last_modified_at > time
    end

    def new_entries_since(time)
      entries.select {|e| time.nil? || (e.published && e.published > time) }
    end
  end
end
