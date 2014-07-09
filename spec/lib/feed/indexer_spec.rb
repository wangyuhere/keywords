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

  describe '#phrases' do
    it 'returns phrases of 2 by default' do
      expect(described_class.new('hello world. good example').phrases).to eql ['hello world', 'good example']
    end

    it 'returns all phrases' do
      expect(described_class.new('how are you').phrases).to eql ['how are', 'are you']
    end

    it 'returns phrases of gram specified' do
      expect(described_class.new('HOW are you').phrases(3)).to eql ['how are you']
    end
  end
end
