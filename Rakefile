require "rake/testtask"

task default: :test

desc "Run tests"
Rake::TestTask.new do |t|
  t.ruby_opts = %w{-W0}
  t.test_files = FileList['test/**/*_test.rb']
end
