require 'rubygems'
require 'bundler/setup'
require 'bundler/gem_tasks'

require 'rake'
require 'rspec'

require_relative 'lib/locomotive/steam'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new('spec')
task default: :spec
