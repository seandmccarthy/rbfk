#!/usr/bin/env ruby
require File.expand_path(File.join('..', '..', 'lib', 'BrainFuck'), __FILE__)

src = ARGF.read
puts BrainFuck.bf_to_ook(src)
