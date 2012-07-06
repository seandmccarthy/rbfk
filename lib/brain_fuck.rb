#!/usr/bin/env ruby -w

class BrainFuck
  DEFAULT_MEMORY_SIZE = 30_000
  DEFAULT_EXEC_LIMIT  = 1_000_000 # Stop badly constructed scripts going forever

  OPS = {
    '+' => :increment,
    '-' => :decrement,
    '>' => :move_pointer_left,
    '<' => :move_pointer_right,
    ',' => :read_in,
    '.' => :print_out,
    '[' => :loop_start,
    ']' => :loop_end
  }

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
    },
    :spoon => {
      1 => '+',
      0 => {
        0 => {
          0 => '-',
          1 => {
            0 => {
              0 => '[',
              1 => {
                0 => '.',
                1 => {
                  0 => ','
                }
              }
            },
            1 => ']'
          }
        },
        1 => {
          0 => '>',
          1 => '<'
        }
      }
    }
  }

  attr_accessor :memory,
                :data_pointer,
                :instruction_pointer,
                :pointer_stack

  def initialize(program_input_stream, options={})
    @debug               = options[:debug] || false
    @exec_limit          = options[:execution_limit] || DEFAULT_EXEC_LIMIT
    @execution_count     = 0

    @instruction_pointer = -1
    @memory_size         = options[:memory_size] || DEFAULT_MEMORY_SIZE
    @memory              = Array.new(@memory_size){ 0 }
    @data_pointer        = 0
    @pointer_stack       = []

    @input_stream        = options[:input_stream] || STDIN
    @output_stream       = options[:output_stream] || STDOUT

    @program             = get_program(program_input_stream)
    @program_end         = @program.size
  end

  def execute(op)
    return unless OPS.has_key?(op)
    puts op if @debug
    send(OPS[op])
    @execution_count += 1
  end

  def increment
    @memory[@data_pointer] += 1
  end

  def decrement
    @memory[@data_pointer] -= 1
  end

  def read_in
    @memory[@data_pointer] = @input_stream.getc.ord
  end

  def print_out
    @output_stream.putc @memory[@data_pointer]
  end

  def move_pointer_left
    @data_pointer += 1
    if @data_pointer == @memory_size
      @data_pointer = 0
    end
  end

  def move_pointer_right
    if @data_pointer > 0
      @data_pointer -= 1
    else
      @data_pointer = @memory_size - 1
    end
  end

  def loop_start
    if @memory[@data_pointer] > 0
      @pointer_stack.push(@instruction_pointer-1)
    else
      @instruction_pointer = matching_brace_position(@instruction_pointer)
    end
  end

  def loop_end
    if @pointer_stack.empty?
      raise "Bracket mismatch"
    end
    if @memory[@data_pointer] == 0
      @pointer_stack.pop
    else
      @instruction_pointer = @pointer_stack.pop
    end
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

  def self.bf_to_ook(bf)
    ook = ''
    ook_bf = DIALECTS[:ook].invert
    bf.each_char do |op|
      next unless op.match(/[\>\<\+\-\.,\[\]]/)
      ook << ook_bf[op]
      ook << ' '
    end
    ook
  end

  def self.spoon_to_bf(spoon)
    src = spoon.gsub(/[^01]/, '')
    bf = ''
    current = DIALECTS[:spoon]
    spoon.each_char do |i|
      current = current[i.to_i]
      unless current.is_a?(Hash)
        bf << current
        current = DIALECTS[:spoon]
      end
    end
    bf
  end

  def run
    while not ended? do
      dump if @debug
      op = next_instruction
      puts "op = #{op}" if @debug
      execute(op)
      dump if @debug
    end
  end

  def next_instruction
    @instruction_pointer += 1
    @program[@instruction_pointer]
  end

  def ended?
    (@instruction_pointer >= @program_end or
     @execution_count >= @exec_limit)
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

  def get_program(program_input_stream)
    src = program_input_stream.read
    if src.match(/(Ook[\.\?\!]\s*){2}/) # Probably Ook
      src = src.gsub(/[\r\n]/, ' ')
      program = BrainFuck.ook_to_bf(src)
    elsif src.match(/^[01]+\s*$/m) # Probably Spoon
      program = BrainFuck.spoon_to_bf(src)
    else
      program = src.gsub(/[^\>\<\+\-\.,\[\]]/, '')
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

end

