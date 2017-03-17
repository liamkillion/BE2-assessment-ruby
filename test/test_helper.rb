ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/reporters'
require 'rack/test'
require File.expand_path '../../app.rb', __FILE__

Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true)]
