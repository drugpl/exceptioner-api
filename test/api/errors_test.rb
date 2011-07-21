require 'test_helper'

class ErrorsTest < Exceptioner::Api::TestCase
  def test_listing_errors_for_project
    post "/v1/notices", valid_notice_params.to_json, valid_headers
    get  "/v1/errors",  valid_headers
    assert_equal 200, last_response.status

    expected_response = {
      :id => "1",
      :exception => "RuntimeError",
      :message => nil,
      :fingerprint => nil,
      :file => nil,
      :mode => nil,
      :updated_at => Time.now.iso8601,
      :created_at => Time.now.iso8601,
      :most_recent_notice_at => Time.now.iso8601,
      :notices_count => 1,
      :resolved => false
    }.with_indifferent_access
    assert_equal [expected_response], last_response.payload
  end

  def test_showing_error_for_project
    post "/v1/notices",  valid_notice_params.to_json, valid_headers
    get  "/v1/errors/1", valid_headers
    assert_equal 200, last_response.status

    expected_response = {
      :id => "1",
      :exception => "RuntimeError",
      :message => nil,
      :backtrace => [],
      :parameters => {},
      :session => {},
      :environment => {},
      :fingerprint => nil,
      :file => nil,
      :mode => nil,
      :updated_at => Time.now.iso8601,
      :created_at => Time.now.iso8601,
      :most_recent_notice_at => Time.now.iso8601,
      :notices_count => 1,
      :resolved => false
    }.with_indifferent_access
    assert_equal expected_response, last_response.payload
  end

  def test_editing_error

  end
end
