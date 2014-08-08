require 'spec_helper'

describe 'The Cargonizer integration' do

  it 'should receive a 200 code when trying to get the transport agreements' do
    url = 'http://sandbox.cargonizer.no/transport_agreements.xml'
    key = '19eb3de20993ff884c017cac3b828082e27ff055'
    managership = '1094'
    response = CargoConnectorHelper::get_transport_agreements(key, managership, url)
    expect(response.code).to eq(200)
  end

  it 'should be able to create a Cargonizer consignment and receive back a 201 Created response' do
    url = 'http://sandbox.cargonizer.no/consignments.xml'
    key = '19eb3de20993ff884c017cac3b828082e27ff055'
    managership = '1094'
    xml = File.read('testdata/consignment.xml')
    response = CargoConnectorHelper::create_consignment(key, managership, url, xml)
    expect(response.code).to eq(201)
  end

  it 'should be able to parse Shopify json and create a consignment xml' do
    file = File.read('testdata/shopify.json')
    shopify_hash = JSON.parse(file)
    transport_agreement = { :id => 1053, :product => 'tg_dpd_innland'}
    xml = CargoConnectorHelper::shopify_hash_to_cargonizer_xml(shopify_hash, transport_agreement)
    expect(xml).to start_with '<?xml'
  end

  it 'should be able to send generated xml to Cargonizer and receive 201 Created response' do
    file = File.read('testdata/shopify.json')
    shopify_hash = JSON.parse(file)
    transport_agreement = { 'id' => 1053, 'product' => 'tg_dpd_innland'}
    url = 'http://sandbox.cargonizer.no/consignments.xml'
    key = '19eb3de20993ff884c017cac3b828082e27ff055'
    managership = '1094'

    xml = CargoConnectorHelper::shopify_hash_to_cargonizer_xml(shopify_hash, transport_agreement)
    response = CargoConnectorHelper::create_consignment(key, managership, url, xml)

    expect(response.code).to eq(201)
    expect(response.body).to start_with '<?xml'
  end

end