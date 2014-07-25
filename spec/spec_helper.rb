require 'rack/test'
require './app.rb'

ENV['RACK_ENV'] = 'test'

module RSpecMixin
  include Rack::Test::Methods
  def app() CargoConnectorApp end
end

RSpec.configure { |c| c.include RSpecMixin }