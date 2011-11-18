require File.expand_path(File.join('..', '..', 'rbfk.rb'), __FILE__)
describe BrainFuck do
    before :each do
        @bf = BrainFuck.new(nil)
    end

    it "should increment" do
        @bf.execute('+')
        @bf.memory[0].should == 1
    end

    it "should decrement" do
        @bf.execute('-')
        @bf.memory[0].should == -1
    end

    it "should increment the data pointer" do
        @bf.execute('>')
        @bf.instruction_pointer.should == 1
    end

    it "should decrement the data pointer" do
        @bf.execute('>')
        @bf.instruction_pointer.should == 1
        @bf.execute('<')
        @bf.instruction_pointer.should == 0
    end
end
