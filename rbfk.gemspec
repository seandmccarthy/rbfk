# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
#require 'rbfk/version'

Gem::Specification.new do |spec|
  spec.name          = "rbfk"
  spec.version       = "1.2.0" #Rbfk::VERSION
  spec.authors       = ["Sean McCarthy"]
  spec.email         = ["sean@clanmccarthy.net"]
  spec.summary       = %q{BrainFuck interpreter.}
  spec.description   = %q{An interpreter for BrainFuck that can also be embedded in your programs.}
  spec.homepage      = "https://github.com/seandmccarthy/rbfk"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
