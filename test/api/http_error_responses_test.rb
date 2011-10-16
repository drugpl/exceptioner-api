require 'test_helper'

class HttpErrorResponsesTest < Exceptioner::Api::TestCase
  def test_sending_invalid_json
    post "/v1/notices", "should_be_json", valid_headers
    assert_equal 400, last_response.status
    assert_equal "Problems parsing JSON", last_response.payload[:message]
  end

  def test_sending_invalid_json_values
    skip
  end

  def test_sending_incomplete_params
    post "/v1/notices", {}.to_json, valid_headers
    assert_equal 422, last_response.status

    last_response.payload.tap do |notice|
      assert_equal "Validation failed", notice[:message]
      notice[:errors].first.tap do |error|
        assert_not_nil error[:resource]
        assert_not_nil error[:field]
        assert_not_nil error[:code]
      end
    end
  end

  def test_sending_wrong_api_version
    skip
  end

  def test_fetching_nonexisting_resource
    get "/v1/notices/13", valid_headers
    assert_equal 404, last_response.status
    assert_equal "Not found", last_response.payload[:message]
  end
end
