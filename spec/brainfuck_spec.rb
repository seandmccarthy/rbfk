require File.expand_path(File.join('..', '..', 'lib', 'brain_fuck'), __FILE__)

describe BrainFuck do
  describe "The Brain Fuck instruction set" do
    before :each do
      @bf = BrainFuck.new(StringIO.new(''))
    end

    it "should increment the value at the current memory location" do
      @bf.execute('+')
      @bf.memory[0].should == 1
    end

    it "should decrement the value at the current memory location" do
      @bf.execute('-')
      @bf.memory[0].should == -1
    end

    it "should increment the data pointer" do
      @bf.execute('>')
      @bf.data_pointer.should == 1
    end

    it "should decrement the data pointer" do
      @bf.execute('>')
      @bf.data_pointer.should == 1
      @bf.execute('<')
      @bf.data_pointer.should == 0
    end

    it "should read a char into the current memory location" do
      STDIN.should_receive(:getc).and_return('A')
      @bf.execute(',')
      @bf.memory[0].should == 65
    end

    it "output the value at the current memory location" do
      @bf.memory[0] = 65
      STDOUT.should_receive(:putc).with(65)
      @bf.execute('.')
    end

    describe "loops" do
      it "should begin a loop when the current memory value is > 0" do
        @bf.execute('+')
        @bf.execute('[')
        @bf.pointer_stack.should_not be_empty
      end

      it "should skip the loop when the current memory value is = 0" do
        @bf.should_receive(:matching_brace_position).and_return(1)
        @bf.execute('[')
        @bf.pointer_stack.should == []
        @bf.instruction_pointer.should == 1
      end

      it "should begin a new iteration when the current memory value is > 0" do

        # Increment current memory position
        @bf.execute('+')

        # Start loop
        @bf.instruction_pointer = 1
        @bf.execute('[')

        # The pointer stack should have (instruction_pointer - 1) pushed on
        @bf.pointer_stack.should == [0]

        # End of loop, should see memory position > zero, then
        #  - pop the last value from pointer_stack
        #  - instruction_pointer should be set to this value
        @bf.execute(']')
        @bf.pointer_stack.should == []
        @bf.instruction_pointer.should == 0
      end

      it "should finish iterating when the current memory value is = 0" do

        # Increment current memory position
        @bf.execute('+')

        # Start loop
        @bf.instruction_pointer = 1
        @bf.execute('[')

        # The pointer stack should have (instruction_pointer - 1) pushed on
        @bf.pointer_stack.should == [0]

        # Decrement current memory position, making it zero
        @bf.execute('-')

        # End of loop, should notice memory position is zero, then
        #  - pop the last value from pointer_stack
        #  - instruction_pointer should (remain) at index for ']' in @program
        @bf.instruction_pointer = 3
        @bf.execute(']')
        @bf.pointer_stack.should == []
        @bf.instruction_pointer.should == 3
      end

      it "should permit nested loops" do
      end

      it "should raise an exception for mismatched braces" do
        lambda { @bf.execute(']') }.should raise_error
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
      BrainFuck.bf_to_ook('-').should == 'Ook! Ook!'
    end
  end
end
