require 'rspec'
require 'rest_client'
require 'rack/test'
require "codeclimate-test-reporter"
require 'webmock/rspec'
CodeClimate::TestReporter.start

require File.join(File.dirname(__FILE__), '../lib/chia/chia.rb')
ENV['RACK_ENV'] = 'test'

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

WebMock.disable_net_connect!(:allow_localhost => true)
RSpec.configure do |config|
  config.color = true
  config.include RSpecMixin 
end
