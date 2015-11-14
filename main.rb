require 'rubygems'
require 'sinatra/base'
require 'sinatra/param'
require 'json'
require 'rack'
require 'mongoid'
require 'config'

class Application < Sinatra::Base
  helpers Sinatra::Param

  post '/user/signup' do

  end

  post '/user/signin' do

  end
end
