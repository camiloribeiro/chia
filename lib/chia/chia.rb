require 'sinatra/base'

class Chia < Sinatra::Base
  get '/' do
    "Hello World!"
  end
end
