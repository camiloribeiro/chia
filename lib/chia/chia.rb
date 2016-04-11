require 'sinatra/base'
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
    #require "pry"; binding.pry
    JSON.pretty_generate get_services["services"][params['service']]
  end

  private
  def get_services
    YAML.load_file('../services.yml')
  end
end
