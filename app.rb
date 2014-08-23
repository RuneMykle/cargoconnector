require 'rubygems'
require 'sinatra'
require 'json'
require 'httparty'
require 'builder'
require './cargo_connector_helper.rb'
require './env' if File.exists?('env.rb')

class CargoConnectorApp < Sinatra::Base

  post '/', :provides => :json do
    halt 400 unless request.content_type == 'application/json'

    request.body.rewind
    data = request.body.read
    #shopify = request.env['X-Shopify-Hmac-SHA256']

    #verified = CargoConnectorHelper::verify_webhook(data, shopify, ENV['SHARED_SECRET'])

    #halt 403 unless verified

    # noinspection RubyStringKeysInHashInspection
    transport_agreement = { 'id' => ENV['CARGONIZER_AGREEMENT_ID'], 'product' => ENV['CARGONIZER_AGREEMENT_PRODUCT']}
    shopify_hash = JSON.parse(data)

    xml = CargoConnectorHelper::shopify_hash_to_cargonizer_xml(shopify_hash, transport_agreement)
    response = CargoConnectorHelper::create_consignment(ENV['CARGONIZER_KEY'], ENV['CARGONIZER_MANAGERSHIP'], ENV['CARGONIZER_URL'], xml)

    puts response

    halt 502 unless response.code == 201

    status 200
  end

end