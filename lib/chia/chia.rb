require 'sinatra/base'
require 'rest-client'
require 'yaml'
require 'json'
require 'datagrid'

class Chia < Sinatra::Base
  get '/' do
    get_services
  end

  get '/json' do
    JSON.pretty_generate get_services
  end

  get "/json/:service" do
    # require "pry"; binding.pry
    JSON.pretty_generate get_services["services"][params['service']]
  end

  get "/status/:service" do
    (get_status_for_service params['service']).to_json
  end

  get "/status" do
    services = JSON.parse get_services["services"].to_json
    response = Hash.new(0)
    services.each do |service_name, service_info|
      response[service_name] = get_status_for_service service_name
    end
    response.to_json
  end

  private

  def get_services
    YAML.load_file('../services.yml')
  end

  def get_status_for_service service_name
    response = RestClient.get get_services["services"][service_name]["status"]["url"] 
    expectation = get_services["services"][service_name]["status"]["expected-response"]
    
    {"health" => (response == expectation)}
  end
end
