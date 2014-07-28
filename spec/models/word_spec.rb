require 'rails_helper'

RSpec.describe Word do
  describe '#find_or_create_ids' do

    before do
      create :word, name: 'a'
    end

    it 'creates words if not found' do
      expect {
        described_class.find_or_create_ids ['a', 'b', 'c']
      }.to change { Word.count }.by 2
    end

    it 'keeps order of given names' do
      ids = described_class.find_or_create_ids ['c', 'b', 'c', 'a']
      a_id = Word.find_by_name('a').id
      b_id = Word.find_by_name('b').id
      c_id = Word.find_by_name('c').id
      expect(ids).to eql [c_id, b_id, c_id, a_id]
    end
  end

  describe '#update_occurrences_count' do
    let(:word) { create :word }

    before do
      create :occurrence, word: word
      Word.update_counters word.id, occurrences_count: -1
    end

    it 'updates occurrences count' do
      expect { word.update_occurrences_count }.to change {word.reload.occurrences_count}.by 1
    end
  end
end
