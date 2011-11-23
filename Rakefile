$: << File.expand_path(File.join(File.dirname(__FILE__), "lib"))

require 'bundler'
require 'rake/testtask'

Bundler::GemHelper.install_tasks

Rake::TestTask.new('test:acceptance') do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/acceptance/*_test.rb'
end

task :default => 'test:acceptance'
