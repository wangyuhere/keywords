require 'rails_helper'

RSpec.describe Occurrence do
  describe '#massive_insert_by_article' do
    let(:article) { create :article }

    it 'inserts multiple occurrences' do
      expect {
        described_class.massive_insert_by_article(article, [1,2,3])
      }.to change { Occurrence.count }.by 3
    end
  end
end
