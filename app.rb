require 'sinatra'
require 'json'
require 'HTTParty'
require 'builder'
require './cargo_connector_helper.rb'

class CargoConnectorApp < Sinatra::Base

  SHARED_SECRET = 'my_shared_secret'
  CARGONIZER_KEY = '19eb3de20993ff884c017cac3b828082e27ff055'
  CARGONIZER_MANAGERSHIP = '1094'
  CARGONIZER_URL = 'http://sandbox.cargonizer.no/consignments.xml'
  CARGONIZER_AGREEMENT_ID = '1053'
  CARGONIZER_AGREEMENT_PRODUCT = 'tg_dpd_innland'

  post '/', :provides => :json do
    halt 400 unless request.content_type == 'application/json'

    request.body.rewind
    data = request.body.read
    shopify = request.env['X-Shopify-Hmac-SHA256']

    verified = CargoConnectorHelper::verify_webhook(data, shopify, SHARED_SECRET)

    halt 403 unless verified

    # noinspection RubyStringKeysInHashInspection
    transport_agreement = { 'id' => CARGONIZER_AGREEMENT_ID, 'product' => CARGONIZER_AGREEMENT_PRODUCT}
    shopify_hash = JSON.parse(data)

    xml = CargoConnectorHelper::shopify_hash_to_cargonizer_xml(shopify_hash, transport_agreement)
    response = CargoConnectorHelper::create_consignment(CARGONIZER_KEY, CARGONIZER_MANAGERSHIP, CARGONIZER_URL, xml)

    halt 502 unless response.code == 201

    status 200
  end

end