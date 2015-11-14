require 'rubygems'
require 'sinatra'
require 'json'
require 'rack'
require 'mongoid'
require 'config'

get '/' do
  { where: 'root' }.to_json
end

get '/user' do
  { where: 'user' }.to_json
end

