require 'test_helper'

class NoticesTest < Exceptioner::Api::TestCase
  def valid_params
    {
      :message => "RuntimeError: booo!",
      :error => {
        :exception => "RuntimeError"
      }
    }
  end

  def test_creating_notice
    post "/v1/notices", valid_params.to_json, valid_headers
    assert_equal 200, last_response.status

    expected_response = {
      :id => "1",
      :error_id => "1",
      :message => "RuntimeError: booo!",
      :updated_at => Time.now.iso8601,
      :created_at => Time.now.iso8601
    }.with_indifferent_access
    assert_equal expected_response, last_response.payload
  end
end
