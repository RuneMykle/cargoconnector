require 'sinatra'
require 'json'
require 'HTTParty'
require 'builder'

class CargoConnectorApp < Sinatra::Base

  post '/', :provides => :json do
    halt 400 unless request.content_type == 'application/json'
    halt 403 unless !request['X-Shopify-Hmac-SHA256'] == '1234'
    status 200

    #key = ENV['cargonizer_key']
    #managership = ENV['cargonizer_managership']
    #CargoConnectorHelper::get_transport_agreements
    #CargoConnectorHelper::create_consignment
  end

end