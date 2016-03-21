require File.expand_path(File.join('..', '..', 'lib', 'brain_fuck'), __FILE__)

describe 'Ook to Brainfuck' do
  it 'translates increment' do
    expect(BrainFuck.ook_to_bf('Ook. Ook.')).to eq '+'
  end

  it 'translates decrement' do
    expect(BrainFuck.ook_to_bf('Ook! Ook!')).to eq '-'
  end

  it 'translates move pointer left' do
    expect(BrainFuck.ook_to_bf('Ook. Ook?')).to eq '>'
  end

  it 'translates move pointer right' do
    expect(BrainFuck.ook_to_bf('Ook? Ook.')).to eq '<'
  end

  it 'translates read' do
    expect(BrainFuck.ook_to_bf('Ook. Ook!')).to eq ','
  end

  it 'translates print' do
    expect(BrainFuck.ook_to_bf('Ook! Ook.')).to eq '.'
  end

  it 'translates loop start' do
    expect(BrainFuck.ook_to_bf('Ook! Ook?')).to eq '['
  end

  it 'translates loop end' do
    expect(BrainFuck.ook_to_bf('Ook? Ook!')).to eq ']'
  end
end
