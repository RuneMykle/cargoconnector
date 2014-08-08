require 'spec_helper'

describe 'The sinatra web server' do

  it 'should respond with a 400 HTTP status code if the body is not json' do
    post '/'
    expect(last_response.status).to equal(400)
  end

  it 'should respond with a 200 HTTP status code if the body is valid json and the request has the correct X-Shopify-Hmac-SHA256 header' do
    post '/', { :key => 'value' }.to_json, { "CONTENT_TYPE" => "application/json", "X-Shopify-Hmac-SHA256" => "1234" }
    expect(last_response.status).to equal(200)
  end

  it 'should respond with a 403 error if it does not include the correct X-Shopify-Hmac-SHA256 header' do
    post '/', { :key => 'value' }.to_json, "CONTENT_TYPE" => "application/json"
    expect(last_response.status).to equal(403)
  end
end