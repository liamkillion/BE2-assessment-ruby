require 'sinatra'
require 'sinatra/json'
require 'sinatra/reloader'
require 'active_record'
require 'faraday'
require 'rest-client'
require 'json'
require 'byebug'

Dir['models/**/*.rb'].each { |file| require_relative file }
also_reload 'models/**/*.rb'

REVIEW_MONKEY_URL = 'http://credentials-api.generalassemb.ly/4576f55f-c427-4cfc-a11c-5bfe914ca6c1'.freeze

ActiveRecord::Base.logger = Logger.new(STDOUT) unless settings.test?
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/database.db'
)

get '/films/:film_id/recommendations' do
  response = RestClient.get(REVIEW_MONKEY_URL)
  byebug
  films = JSON.parse(response)
  byebug
  film = films.each {|film| film.film_id===params["film_id"].to_i}
end

get '/' do
   'Testing'
end
