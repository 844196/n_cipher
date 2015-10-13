require "bundler/gem_tasks"
require 'rubocop/rake_task'
require 'yard'
require 'yard/rake/yardoc_task'

task :default => :test

task :test do
  ruby("test/test_helper.rb")
end

RuboCop::RakeTask.new

YARD::Rake::YardocTask.new do |t|
  t.files = ['lib/**/*.rb']
end
