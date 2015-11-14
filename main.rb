require 'rubygems'
require 'sinatra'
require 'json'
require 'rack'
require 'mongoid'
require 'config'

get '/' do
  body "Hello world"
end

get '/user' do
  body "User World"
end

