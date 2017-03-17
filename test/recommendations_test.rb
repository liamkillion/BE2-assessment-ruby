require File.expand_path '../test_helper', __FILE__

class RecommendationsTest < MiniTest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_it_works
    get '/films/3/recommendations'
    assert last_response.ok?
  end
end
