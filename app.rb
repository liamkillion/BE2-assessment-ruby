require 'sinatra'
require 'sinatra/json'
require 'sinatra/reloader'
require 'active_record'
require 'faraday'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/database.db'
)

get '/films/:film_id/recommendations' do
  puts params
end
