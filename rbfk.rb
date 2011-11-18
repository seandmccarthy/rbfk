#!/usr/bin/env ruby -w

class BrainFuck
  MEMORY_SIZE = 30_000
  LIMIT       = 1_000_000 # Stop badly constructed scripts going forever

  DIALECTS = {
    :ook => {
      'Ook. Ook.' => '+',
      'Ook! Ook!' => '-',
      'Ook. Ook?' => '>',
      'Ook? Ook.' => '<',
      'Ook! Ook?' => '[',
      'Ook? Ook!' => ']',
      'Ook! Ook.' => '.',
      'Ook. Ook!' => ','
    }
  }

  attr_accessor :memory,
                :data_pointer,
                :instruction_pointer,
                :pointer_stack

  def initialize(input_stream, debug=false)
    @input_stream        = input_stream
    @debug               = debug
    @execution_count     = 0

    @instruction_pointer = 0
    @memory              = Array.new(MEMORY_SIZE){ 0 }
    @data_pointer        = 0
    @pointer_stack       = []
  end

  def execute(op)
    puts op if @debug
    case op
    when '>'
      @data_pointer += 1
    when '<'
      if @data_pointer > 0
        @data_pointer -= 1
      else
        @data_pointer = MEMORY_SIZE - 1
      end
    when '+'
      @memory[@data_pointer] += 1
      if @data_pointer == MEMORY_SIZE
        @data_pointer = 0
      end
    when '-'
      @memory[@data_pointer] -= 1
    when '.'
      putc @memory[@data_pointer]
    when ',' 
      @memory[@data_pointer] = STDIN.getc.ord
    when '['
      if @memory[@data_pointer] > 0
        @pointer_stack.push(@instruction_pointer-1)
      else
        @instruction_pointer = matching_brace_position(@instruction_pointer)
      end
    when ']'
      if @pointer_stack.empty?
        raise "Bracket mismatch"
      end
      if @memory[@data_pointer] == 0
        @pointer_stack.pop
      else
        @instruction_pointer = @pointer_stack.pop
      end
    end
    @execution_count += 1
  end

  def self.ook_to_bf(ook)
    bf = ''
    ook.scan(/(Ook[\.\?\!])\s*(Ook[\.\?\!])/) do |m|
      command = "#{m[0]} #{m[1]}"
      unless DIALECTS[:ook].include?(command)
        raise "Got confused, thought it was Ook!"
      end
      bf << DIALECTS[:ook][command]
    end
    bf
  end

  def run
    @program = get_program
    @program_end = @program.size

    while !ended? do
      dump if @debug
      op = @program[@instruction_pointer]
      execute(op)
      dump if @debug
      @instruction_pointer += 1
    end
  end

  def ended?
    (@instruction_pointer >= @program_end or @execution_count >= LIMIT)
  end

  def dump
    puts
    puts "instruction_pointer = #{@instruction_pointer}"
    puts "data_pointer    = #{@data_pointer}"
    puts "memory@data_pointer = #{@memory[@data_pointer]}"
    puts "pointer_stack     = #{@pointer_stack.inspect}"
    puts
  end

  private

  def get_program
    program = ''
    @input_stream.each do |line|
      if line.match(/(Ook[\.\?\!]\s*){2}/) # Probably Ook
        program << ook_to_bf(line)
      else
        program << line.gsub(/[^\>\<\+\-\.,\[\]]/, '')
      end
    end
    program
  end

  def matching_brace_position(pointer)
    begin
      pointer += 1
      raise "Bracket mismatch" if pointer >= @program_end
      if @program[pointer] == '['
        pointer = matching_brace_position(pointer) + 1
      end
    end until @program[pointer] == ']'
    pointer
  end

  if __FILE__ == $PROGRAM_NAME
    bf = BrainFuck.new(ARGF)
    bf.run
  end

end

