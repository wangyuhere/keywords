require 'rails_helper'

RSpec.describe WordPresenter do
  let(:subject) { WordPresenter.new word }

  describe '#occurrences_per_article' do
    let(:word) { build :word, occurrences_count: 100, articles_count: 30 }

    it 'calculates correct dates and round 2 for float' do
      expect(subject.occurrences_per_article).to eql 3.33
    end

    context 'word with 0 occurrences' do
      let(:word) { build :word }

      it 'shows 0' do
        expect(subject.occurrences_per_article).to eql 0
      end
    end
  end
end
