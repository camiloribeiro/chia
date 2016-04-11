require File.dirname(__FILE__) + "/spec_helper"
require File.join(File.dirname(__FILE__), '../lib/chia/chia.rb')

describe Chia do

  def app
    Chia.new
  end

  describe "Get Operations" do
    it "GET: get to /" do
      get '/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq("Hello World!")
    end
  end
end
