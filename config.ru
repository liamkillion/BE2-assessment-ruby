#\ -p 3000
require 'rubygems'
require 'bundler'
require 'warning'

Warning.ignore %i{fixnum bignum}

RACK_ENV ||= ENV['RACK_ENV'] || 'development'
Bundler.require(:default, RACK_ENV)

require File.expand_path('../app.rb', __FILE__)

run Sinatra::Application
