require 'rubygems'
require 'sinatra/base'
require 'sinatra/param'
require 'json'
require 'rack'
require 'mongoid'
require 'config'

class App < Sinatra::Base
  helpers Sinatra::Param

  get '/' do
    body "Hello world"
  end

  get '/user' do
    body "User World"
  end

end
