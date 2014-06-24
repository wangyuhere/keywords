require 'spec_helper'
require 'feed/indexer'

RSpec.describe Feed::Indexer do
  describe '#tokens' do
    it 'returns words' do
      expect(described_class.new('hello world').tokens).to eql ['hello', 'world']
    end

    it 'rejects words with length 1' do
      expect(described_class.new('hello a').tokens).to eql ['hello']
    end

    it 'downcase words' do
      expect(described_class.new('Hello WORLD').tokens).to eql ['hello', 'world']
    end
  end
end
