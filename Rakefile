require "bundler/gem_tasks"
require 'rubocop/rake_task'

task :default => :test

task :test do
  ruby("test/test_helper.rb")
end

RuboCop::RakeTask.new
