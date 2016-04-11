require File.dirname(__FILE__) + "/spec_helper"
require File.join(File.dirname(__FILE__), '../lib/chia/chia.rb')

describe Chia do

  def app
    Chia.new
  end

  describe "Getting descriptinos of services under monitoring" do

    it "Get all services as a json" do
      get '/json'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq(
        '{
  "services": {
    "service-in-scala": {
      "status": {
        "url": "http://scala.com/ping",
        "expected-code": "200",
        "expected-response": "pong"
      },
      "health-url": "http://scala.com"
    },
    "service-in-java": {
      "status": {
        "url": "http://java.com/ping",
        "expected-code": "200",
        "expected-response": "ok"
      },
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
  "status": {
    "url": "http://scala.com/ping",
    "expected-code": "200",
    "expected-response": "pong"
  },
  "health-url": "http://scala.com"
}')
    end
  end

  describe "Getting status of services under monitoring" do
    
    it "Get status to all services when all of them are health" do
      stub_request(:get, "http://scala.com/ping").
        to_return(:status => 200, :body => "pong", :headers => {})
      stub_request(:get, "http://java.com/ping").
        to_return(:status => 200, :body => "ok", :headers => {})

      get '/status'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq( '{"service-in-scala":{"health":true},"service-in-java":{"health":true}}')
    end

    it "Get status to all services when all of them are unnhealth" do
      stub_request(:get, "http://scala.com/ping").
        to_return(:status => 200, :body => "foo", :headers => {})
      stub_request(:get, "http://java.com/ping").
        to_return(:status => 200, :body => "bar", :headers => {})

      get '/status'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq( '{"service-in-scala":{"health":false},"service-in-java":{"health":false}}')
    end

    it "Get status for a single service when it is health" do
      stub_request(:get, "http://scala.com/ping").
        to_return(:status => 200, :body => "pong", :headers => {})

      get '/status/service-in-scala'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq( '{"health":true}')
    end

    it "Get status for a single service when it is not health" do
      stub_request(:get, "http://scala.com/ping").
        to_return(:status => 200, :body => "foo", :headers => {})

      get '/status/service-in-scala'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq( '{"health":false}')
    end

  end

end
