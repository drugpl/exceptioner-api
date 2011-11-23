require 'test_helper'

class ExceptionerAPIFTWTest < Exceptioner::API::TestCase
  def setup
    @client = TestClient.new
  end

  def test_default_response
    @client.get('/') do |data|
      assert_equal "exceptioner-api FTW!", data.response
    end
  end
end
