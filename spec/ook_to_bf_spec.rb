require File.expand_path(File.join('..', '..', 'lib', 'brainfuck'), __FILE__)

module Brainfuck
  describe 'Ook to Brainfuck' do
    it 'translates increment' do
      expect(Dialect::Ook.to_bf('Ook. Ook.')).to eq '+'
    end

    it 'translates decrement' do
      expect(Dialect::Ook.to_bf('Ook! Ook!')).to eq '-'
    end

    it 'translates move pointer left' do
      expect(Dialect::Ook.to_bf('Ook. Ook?')).to eq '>'
    end

    it 'translates move pointer right' do
      expect(Dialect::Ook.to_bf('Ook? Ook.')).to eq '<'
    end

    it 'translates read' do
      expect(Dialect::Ook.to_bf('Ook. Ook!')).to eq ','
    end

    it 'translates print' do
      expect(Dialect::Ook.to_bf('Ook! Ook.')).to eq '.'
    end

    it 'translates loop start' do
      expect(Dialect::Ook.to_bf('Ook! Ook?')).to eq '['
    end

    it 'translates loop end' do
      expect(Dialect::Ook.to_bf('Ook? Ook!')).to eq ']'
    end
  end
end
