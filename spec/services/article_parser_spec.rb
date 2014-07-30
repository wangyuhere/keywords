require 'rails_helper'

RSpec.describe ArticleParser do
  let(:source) { create :source, css_selector: '#article-content .articletext' }
  let(:article) { create :article, url: 'http://www.svd.se/nyheter/inrikes/3678566.svd', source: source }
  let(:subject) { described_class.new article }

  describe '#parse!' do
    it 'fetches from url and update the body' do
      VCR.use_cassette('svd_page') do
        subject.parse!
      end
      expect(article.body).to start_with('En jämnårig man har också begärts häktad')
    end
  end
end
