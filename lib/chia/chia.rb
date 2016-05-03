require 'sinatra/base'
require 'rest-client'
require 'yaml'
require 'json'

class Chia < Sinatra::Base

  get '/' do
    File.read(File.join('public', 'index.html'))
  end

  get '/css/style.css' do
    content_type :css
    File.read(File.join('public/css/', 'style.css'))
  end

  get '/scripts/app.js' do
    File.read(File.join('public/scripts/', 'app.js'))
  end

  get '/my_status' do
    '{"chia":{"health":true}}'
  end

  get '/json' do
    JSON.pretty_generate get_services
  end

  get "/json/:service" do
    JSON.pretty_generate get_services["services"][params['service']]
  end

  get "/status/:service" do
    (get_status_for_service params['service']).to_json
  end

  get "/status" do
    services = JSON.parse get_services["services"].to_json
    response = []
    services.each do |service_name, service_info|
      response << "{\"name\": \"#{service_name}\", \"health\": \"#{(get_status_for_service service_name)}\"}"
    end
    "[#{response.join(",")}]"
  end

  private

  def get_services
    YAML.load_file('services.yml')
  end

  def get_status_for_service service_name
    begin
      require "pry"; binding.pry
      response = RestClient.get get_services["services"][service_name]["status"]["url"] 
    rescue => e
      response = e.response
    end

    expectation = get_services["services"][service_name]["status"]["expected-response"]
    (response == expectation)
  end
end
