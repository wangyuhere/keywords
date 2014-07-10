require 'spec_helper'
require 'analyze/phrases'

RSpec.describe Analyze::Phrases do
  describe '#to_a' do
    it 'returns phrases of 2 by default' do
      expect(described_class.new('hello world. good example').to_a).to eql ['hello world', 'good example']
    end

    it 'returns all phrases' do
      expect(described_class.new('how are you').to_a).to eql ['how are', 'are you']
    end

    it 'returns phrases of gram specified' do
      expect(described_class.new('HOW are you', 3).to_a).to eql ['how are you']
    end

    it 'rejects phrases with one word' do
      expect(described_class.new('hello world. - example').to_a).to eql ['hello world']
    end
  end
end
