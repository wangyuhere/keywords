require 'rails_helper'

RSpec.describe Article do
  let(:source) { create :source, css_selector: '#article-content .articletext' }
  let(:subject) { create :article, url: 'http://www.svd.se/nyheter/inrikes/3678566.svd', source: source }

  describe '#text' do
    it 'returns title and body' do
      expect(subject.text).to eq "#{subject.title} #{subject.body}"
    end
  end

  describe '#parse!' do
    it 'fetches from url and update the body' do
      VCR.use_cassette('svd_page') do
        subject.parse!
      end
      expect(subject.body).to start_with('En jämnårig man har också begärts häktad')
    end
  end

  describe '#index!' do
    context 'with old occurrences' do
      before { subject.words << create(:word) }

      it 'deletes all old occurrences' do
        subject.index!
        expect(subject.occurrences.count).to eql 2
      end
    end

    it 'adds all occurrences' do
      subject.index!
      expect(subject.occurrences.count).to eql 2
    end

    it 'updates index_at' do
      subject.index!
      expect(subject.indexed_at).not_to be_nil
    end

    it 'updates word occurrences count' do
      subject.index!
      subject.occurrences.map do |o|
        expect(o.word.occurrences_count).to eql 1
      end
    end
  end
end
