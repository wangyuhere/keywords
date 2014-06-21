require 'rails_helper'
require 'open-uri'

RSpec.describe Source do
  let(:feed_url) { 'http://www.aftonbladet.se/rss.xml' }
  let(:subject) { create :source, feed_url: feed_url }
  let(:feed) { Feedjira::Feed.parse(open(feed_url).read) }

  before do
    VCR.use_cassette('feed_rss') do
      # feedjira does not work with VCR, so using open-uri to fetch the feed.
      allow(Feedjira::Feed).to receive(:fetch_and_parse).with(feed_url).and_return(feed)
    end
  end

  describe '.from_feed' do
    let(:title) { 'Aftonbladet: Sveriges nyhetskälla och mötesplats' }
    let(:url) { 'http://www.aftonbladet.se/' }

    context 'source not exists' do
      it 'creates a source' do
        expect { Source.from_feed feed_url }.to change { Source.count }.by 1
      end
    end

    context 'source exists' do
      before { subject }

      it 'does not create new source' do
        expect { Source.from_feed feed_url }.to change { Source.count }.by 0
      end
    end

    it 'updates feed_url, title, url' do
      s = Source.from_feed feed_url
      expect(s.feed_url).to eql feed_url
      expect(s.title).to eql title
      expect(s.url).to eql url
    end
  end

  describe '#fetch!' do
    it 'saves articles from feed' do
      expect { subject.fetch! }.to change { subject.articles.count }.by feed.entries.count
    end

    it 'updates last_modified_at' do
      expect { subject.fetch! }.to change { subject.last_modified_at }.to feed.last_modified
    end

    context 'already updated' do
      it 'does not add old articles' do
        subject.last_modified_at = Time.now
        expect { subject.fetch! }.to change { subject.articles.count }.by 0
      end
    end
  end
end
