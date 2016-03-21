require File.expand_path(File.join('..', '..', 'lib', 'brain_fuck'), __FILE__)

describe BrainFuck do
  describe "The Brain Fuck instruction set" do
    before :each do
      @bf = BrainFuck.new(StringIO.new(''))
    end

    it "should increment the value at the current memory location" do
      @bf.execute('+')
      expect(@bf.memory[0]).to eq 1
    end

    it "should decrement the value at the current memory location" do
      @bf.execute('-')
      expect(@bf.memory[0]).to eq -1
    end

    it "should increment the data pointer" do
      @bf.execute('>')
      expect(@bf.data_pointer).to eq 1
    end

    it "should decrement the data pointer" do
      @bf.execute('>')
      expect(@bf.data_pointer).to eq 1
      @bf.execute('<')
      expect(@bf.data_pointer).to eq 0
    end

    it "should read a char into the current memory location" do
      bf = BrainFuck.new(StringIO.new(''), input_stream: StringIO.new('A'))
      bf.execute(',')
      expect(bf.memory[0]).to eq 65
    end

    it "output the value at the current memory location" do
      output = StringIO.new
      bf = BrainFuck.new(StringIO.new(''), output_stream: output)
      bf.memory[0] = 65
      bf.execute('.')
      output.seek(0)
      expect(output.read).to eq 'A'
    end

    describe "loops" do
      it "should begin a loop when the current memory value is > 0" do
        @bf.execute('+')
        @bf.execute('[')
        expect(@bf.pointer_stack).to_not be_empty
      end

      it "should skip the loop when the current memory value is = 0" do
        expect(@bf).to receive(:matching_brace_position).and_return(1)
        @bf.execute('[')
        expect(@bf.pointer_stack).to eq []
        expect(@bf.instruction_pointer).to eq 1
      end

      it "should begin a new iteration when the current memory value is > 0" do

        # Increment current memory position
        @bf.execute('+')

        # Start loop
        @bf.instruction_pointer = 1
        @bf.execute('[')

        # The pointer stack should have (instruction_pointer - 1) pushed on
        expect(@bf.pointer_stack).to eq [0]

        # End of loop, should see memory position > zero, then
        #  - pop the last value from pointer_stack
        #  - instruction_pointer should be set to this value
        @bf.execute(']')
        expect(@bf.pointer_stack).to eq []
        expect(@bf.instruction_pointer).to eq 0
      end

      it "should finish iterating when the current memory value is = 0" do
        # Increment current memory position
        @bf.execute('+')

        # Start loop
        @bf.instruction_pointer = 1
        @bf.execute('[')

        # The pointer stack should have (instruction_pointer - 1) pushed on
        expect(@bf.pointer_stack).to eq [0]

        # Decrement current memory position, making it zero
        @bf.execute('-')

        # End of loop, should notice memory position is zero, then
        #  - pop the last value from pointer_stack
        #  - instruction_pointer should (remain) at index for ']' in @program
        @bf.instruction_pointer = 3
        @bf.execute(']')
        expect(@bf.pointer_stack).to eq []
        expect(@bf.instruction_pointer).to eq 3
      end

      it "should permit nested loops" do
      end

      it "should raise an exception for mismatched braces" do
        expect { @bf.execute(']') }.to raise_error 'Bracket mismatch'
      end
    end

  end

  describe "running programs" do
    it "should indicate when a program execution should end" do
      @bf = BrainFuck.new(StringIO.new(''))
      expect(@bf.ended?).to be false
      @bf.next_instruction
      expect(@bf.ended?).to be true
    end
  end

  describe "Translating and executing other dialects" do
    it 'translate brainfuck to Ook' do
      expect(BrainFuck.bf_to_ook('-')).to eq 'Ook! Ook!'
    end
  end
end
