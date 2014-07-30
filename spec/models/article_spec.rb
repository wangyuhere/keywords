require 'rails_helper'

RSpec.describe Article do
  let(:subject) { create :article }

  describe '#text' do
    it 'returns title and body' do
      expect(subject.text).to eq "#{subject.title}: #{subject.body}"
    end
  end
end
