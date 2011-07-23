require 'test_helper'

class ErrorsTest < Exceptioner::Api::TestCase
  def test_listing_errors_for_project
    post "/v1/notices", valid_notice_params.to_json, valid_headers
    time = Time.now.iso8601

    get  "/v1/errors",  valid_headers
    assert_equal 200, last_response.status
    assert_equal 1,   last_response.payload.size

    last_response.payload.first.tap do |error|
      assert_not_nil error[:id]
      assert_not_nil error[:fingerprint]
      assert_equal valid_error_params[:exception], error[:exception]
      assert_equal valid_error_params[:file], error[:file]
      assert_equal valid_error_params[:mode], error[:mode]
      assert_equal time, error[:created_at]
      assert_equal time, error[:updated_at]
      assert_equal time, error[:most_recent_notice_at]
      assert_equal false, error[:resolved]
      assert_equal 1, error[:notices_count]
    end
  end

  def test_showing_error_for_project
    post "/v1/notices",  valid_notice_params.to_json, valid_headers
    time      = Time.now.iso8601
    error_id  = last_response.payload[:error_id]

    get  "/v1/errors/#{error_id}", valid_headers
    assert_equal 200, last_response.status

    last_response.payload.tap do |error|
      assert_not_nil error[:id]
      assert_not_nil error[:fingerprint]
      assert_equal valid_error_params[:exception], error[:exception]
      assert_equal valid_error_params[:file], error[:file]
      assert_equal valid_error_params[:mode], error[:mode]
      assert_equal valid_error_params[:backtrace], error[:backtrace]
      assert_equal valid_error_params[:parameters], error[:parameters]
      assert_equal valid_error_params[:session], error[:session]
      assert_equal valid_error_params[:environment], error[:environment]
      assert_equal time, error[:created_at]
      assert_equal time, error[:updated_at]
      assert_equal time, error[:most_recent_notice_at]
      assert_equal false, error[:resolved]
      assert_equal 1, error[:notices_count]
    end
  end

  def test_editing_error
    skip
  end
end
