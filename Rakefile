require 'rubygems'
require 'bundler/setup'
require 'bundler/gem_tasks'

require 'rake'
require 'rspec'

# === Gems install tasks ===
Bundler::GemHelper.install_tasks

# require 'coveralls/rake/task'
# Coveralls::RakeTask.new

require_relative 'lib/locomotive/steam'

namespace :mongodb do
  namespace :test do
    desc 'Seed the MongoDB database with the dump of the Sample website'
    task :seed do
      path = File.join(File.expand_path(File.dirname(__FILE__)), 'spec', 'fixtures', 'mongodb')
      `mongo steam_test --eval "db.dropDatabase()"`
      `mongorestore -d steam_test #{path}`
    end
  end
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new('spec')

RSpec::Core::RakeTask.new('spec:integration') do |spec|
  spec.pattern = 'spec/integration/**/*_spec.rb'
end

RSpec::Core::RakeTask.new('spec:unit') do |spec|
  spec.pattern = 'spec/unit/**/*_spec.rb'
end

task default: ['mongodb:test:seed', :spec]
