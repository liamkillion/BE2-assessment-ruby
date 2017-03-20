ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/reporters'
require 'rack/test'
require 'pry'
require File.expand_path '../../app.rb', __FILE__

Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true)]

class MiniTest::Spec
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def parsed_body
    ::MultiJson.decode(last_response.body, symbolize_keys: true)
  end
end
