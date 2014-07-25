require 'sinatra'

class CargoConnectorApp < Sinatra::Base
  get '/' do
    "Hello World"
  end
end