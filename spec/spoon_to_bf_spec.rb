require File.expand_path(File.join('..', '..', 'lib', 'brain_fuck'), __FILE__)

describe 'Spoon to Brainfuck' do
  it 'translates increment' do
    expect(BrainFuck.spoon_to_bf('1')).to eq '+'
  end

  it 'translates decrement' do
    expect(BrainFuck.spoon_to_bf('000')).to eq '-'
  end
end
