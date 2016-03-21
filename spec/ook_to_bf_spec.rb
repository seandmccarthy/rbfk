require File.expand_path(File.join('..', '..', 'lib', 'brain_fuck'), __FILE__)

describe 'Ook to Brainfuck' do
  it 'translates increment' do
    expect(BrainFuck.ook_to_bf('Ook. Ook.')).to eq '+'
  end
end
