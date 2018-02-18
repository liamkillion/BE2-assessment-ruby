require 'sinatra'
require 'sinatra/json'
require 'sinatra/reloader'
require 'active_record'
require 'faraday'
require 'json'
require 'pry'

Dir['models/**/*.rb'].each { |file| require_relative file }
also_reload 'models/**/*.rb'

REVIEW_MONKEY_URL = 'http://credentials-api.generalassemb.ly/4576f55f-c427-4cfc-a11c-5bfe914ca6c1'.freeze

ActiveRecord::Base.logger = Logger.new(STDOUT) unless settings.test?
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/database.db'
)

get '/films/:film_id/recommendations' do
  # all films
  films=Film.all
  # film that needs recommendations
  target_film=Film.find(params[:film_id])
  # all films in the same genre as the film needing recommendations
  genre_films = films.select{|film|film.genre===target_film.genre}
  # all films in the same genre that have more than 5 ratings and an average of 4+
  rated_genre_films = []
  genre_films.each do |film|
    # check film's reviews
    url = "#{REVIEW_MONKEY_URL}?films=#{film.id}"
    response = Faraday.get(url)
    # prase out reviews
    reviews = response['reviews']
    #assess average score
    cumulative_ratings = 0
    reviews.each{|review| review['rating'] +=  cumulative_ratings}
    # if the film (from genre films) meets the criteria, add to rated_genre_films
    if reviews.length>5 && cumulative_ratings/reviews.length>4 do
        rated_genre_films.push(film)
    end
  end
  #sort films which meet the criteria by ID
  sorted_rated_genre_films = rated_genre_films.sort_by { |film| film["id"] }
  render json: sorted_rated_genre_films
end


get '/films/:film_id/reviews' do
  url = "#{REVIEW_MONKEY_URL}?films=#{params[:film_id]}"
  response = Faraday.get(url)
  # binding.pry
  render json: JSON.parse(response.body)
end


get '/' do
   'Testing'
end
