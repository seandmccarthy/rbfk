module Brainfuck::Dialect
  class Ook
    MAPPING = {
      'Ook. Ook.' => '+',
      'Ook! Ook!' => '-',
      'Ook. Ook?' => '>',
      'Ook? Ook.' => '<',
      'Ook! Ook?' => '[',
      'Ook? Ook!' => ']',
      'Ook! Ook.' => '.',
      'Ook. Ook!' => ','
    }

    def self.to_bf(ook)
      bf = []
      ook.scan(/(Ook[\.\?\!])\s*(Ook[\.\?\!])/) do |m|
        command = "#{m[0]} #{m[1]}"
        raise "Could not parse #{command} as Ook!" unless MAPPING.include?(command)
        bf << MAPPING[command]
      end
      bf.join
    end
  end
end
