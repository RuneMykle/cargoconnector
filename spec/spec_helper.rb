require 'rack/test'
require './app.rb'
require './cargo_connector_helper.rb'

ENV['RACK_ENV'] = 'test'

module RSpecMixin
  include Rack::Test::Methods
  def app() CargoConnectorApp end
end

RSpec.configure { |c| c.include RSpecMixin }