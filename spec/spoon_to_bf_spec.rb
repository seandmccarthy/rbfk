require File.expand_path(File.join('..', '..', 'lib', 'brain_fuck'), __FILE__)

describe 'Spoon to Brainfuck' do
  it 'translates increment' do
    expect(BrainFuck.spoon_to_bf('1')).to eq '+'
  end

  it 'translates decrement' do
    expect(BrainFuck.spoon_to_bf('000')).to eq '-'
  end

  it 'translates move pointer left' do
    expect(BrainFuck.spoon_to_bf('010')).to eq '>'
  end

  it 'translates move pointer right' do
    expect(BrainFuck.spoon_to_bf('011')).to eq '<'
  end

  it 'translates read' do
    expect(BrainFuck.spoon_to_bf('0010110')).to eq ','
  end

  it 'translates print' do
    expect(BrainFuck.spoon_to_bf('001010')).to eq '.'
  end

  it 'translates loop start' do
    expect(BrainFuck.spoon_to_bf('00100')).to eq '['
  end

  it 'translates loop end' do
    expect(BrainFuck.spoon_to_bf('0011')).to eq ']'
  end
end
