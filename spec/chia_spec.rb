require File.dirname(__FILE__) + "/spec_helper"
require File.join(File.dirname(__FILE__), '../lib/chia/chia.rb')

describe Chia do

  def app
    Chia.new
  end

  describe "Get Operations" do

    it "Get all services as a json" do
      get '/json'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq(
        '{
  "services": {
    "service-in-scala": {
      "health-url": "http://scala.com"
    },
    "service-in-java": {
      "health-url": "http://java.com"
    }
  }
}')
    end
    
    it "Get data from specific service" do
      get '/json/service-in-scala'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq(
        '{
  "health-url": "http://scala.com"
}')
    end
  end
end
