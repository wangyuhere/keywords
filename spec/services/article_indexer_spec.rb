require 'rails_helper'

RSpec.describe ArticleIndexer do
  let(:article) { create :article }
  let(:subject) { described_class.new article }

  describe '#index!' do
    context 'with old occurrences' do
      before { article.words << create(:word) }

      it 'deletes all old occurrences' do
        expect(article.occurrences.count).to eql 1
        subject.index!
        expect(article.occurrences.count).to eql 2
      end
    end

    it 'adds all occurrences' do
      subject.index!
      expect(article.occurrences.count).to eql 2
    end

    it 'updates index_at' do
      subject.index!
      expect(article.indexed_at).not_to be_nil
    end

    it 'updates counter cache in word' do
      subject.index!
      article.occurrences.map do |o|
        expect(o.word.occurrences_count).to eql 1
        expect(o.word.articles_count).to eql 1
      end
    end
  end
end
