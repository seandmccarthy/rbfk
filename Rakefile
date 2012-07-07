# encoding: utf-8

require 'rubygems'
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "rbfk"
  gem.homepage = "http://github.com/seandmccarthy/rbfk"
  gem.license = "MIT"
  gem.summary = %Q{BrainFuck interpreter}
  gem.description = %Q{An interpreter for BrainFuck that can also be embedded in your programs}
  gem.email = "sean@clanmcccarthy.net"
  gem.authors = ["Sean McCarthy"]
  gem.add_development_dependency "rspec", "~> 2.8.0"
  gem.add_development_dependency "rdoc", "~> 3.12"
  gem.add_development_dependency "bundler", "~> 1.0.0"
  gem.add_development_dependency "jeweler", "~> 1.8.3"
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rbfk #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
