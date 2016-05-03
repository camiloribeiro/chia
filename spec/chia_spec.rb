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
        "url": "http://scala/ping",
        "expected-code": "200",
        "expected-response": "pong"
      },
      "health-url": "http://scala.com"
    },
    "service-in-java": {
      "status": {
        "url": "http://java/ping",
        "expected-code": "200",
        "expected-response": "ok"
      },
      "health-url": "http://java.com"
    },
    "service-in-go": {
      "status": {
        "url": "http://go/ping",
        "expected-code": "200",
        "expected-response": "health"
      },
      "health-url": "http://go.com"
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
    "url": "http://scala/ping",
    "expected-code": "200",
    "expected-response": "pong"
  },
  "health-url": "http://scala.com"
}')
    end
  end

  describe "Getting status of services under monitoring" do
    
    it "Get status to all services when all of them are health" do
      stub_request(:get, "http://scala/ping").
        to_return(:status => 200, :body => "pong", :headers => {})
      stub_request(:get, "http://java/ping").
        to_return(:status => 200, :body => "ok", :headers => {})
      stub_request(:get, "http://go/ping").
        to_return(:status => 200, :body => "health", :headers => {})

      get '/status'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq( '[{"name": "service-in-scala", "health": "true"},{"name": "service-in-java", "health": "true"},{"name": "service-in-go", "health": "true"}]')
    end

    it "Get status to all services when all of them are unnhealth" do
      stub_request(:get, "http://scala/ping").
        to_return(:status => 200, :body => "foo", :headers => {})
      stub_request(:get, "http://java/ping").
        to_return(:status => 200, :body => "bar", :headers => {})
      stub_request(:get, "http://go/ping").
        to_return(:status => 200, :body => "meh", :headers => {})

      get '/status'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq( '[{"name": "service-in-scala", "health": "false"},{"name": "service-in-java", "health": "false"},{"name": "service-in-go", "health": "false"}]')
    end

    it "Get status for a single service when it is health" do
      stub_request(:get, "http://scala/ping").
        to_return(:status => 200, :body => "pong", :headers => {})

      get '/status/service-in-scala'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq( 'true')
    end

    it "Get status for a single service when it is not health" do
      stub_request(:get, "http://scala/ping").
        to_return(:status => 200, :body => "foo", :headers => {})

      get '/status/service-in-scala'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq( 'false')
    end

    it "Get status for a single service when there is a intenal server error" do
      stub_request(:get, "http://scala/ping").
        to_return(:status => 500, :body => "There is no Internet connection", :headers => {})

      get '/status/service-in-scala'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq( 'false')
    end

    it "Get status for a single service when there is no response" do
      stub_request(:get, "http://scala/ping").
        to_return(:status => 0, :body => "", :headers => {})

      get '/status/service-in-scala'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq( 'false')
    end

  end

  describe "Getting its own status" do
    it "Service should return itself as health at all times" do
      get '/my_status'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq( '{"chia":{"health":true}}')
    end
  end

  describe "Getting static content" do
    it "Service should return 200 when requesting html" do
      get '/'
      expect(last_response.status).to eq(200)
    end
    it "Service should return 200 when requesting css" do
      get '/css/style.css'
      expect(last_response.status).to eq(200)
    end
    it "Service should return 200 when requesting js" do
      get '/scripts/app.js'
      expect(last_response.status).to eq(200)
    end
  end

end
