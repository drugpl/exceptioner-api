require 'test_helper'

class NoticesTest < Exceptioner::Api::TestCase
  def test_creating_valid_notice
    post "/v1/notices", valid_notice_params.to_json, valid_headers
    time = Time.now.iso8601
    assert_equal 201, last_response.status

    last_response.payload.tap do |notice|
      assert_not_nil notice[:id]
      assert_not_nil notice[:error_id]
      assert_equal valid_notice_params[:message], notice[:message]
      assert_equal time, notice[:created_at]
      assert_equal time, notice[:updated_at]
    end
  end

  def test_listing_notices_for_error
    post "/v1/notices", valid_notice_params.to_json, valid_headers
    time     = Time.now.iso8601
    error_id = last_response.payload[:error_id]

    get  "/v1/errors/#{error_id}/notices", valid_headers
    assert_equal 200, last_response.status
    assert_equal 1,   last_response.payload.size

    last_response.payload.first.tap do |notice|
      assert_not_nil notice[:id]
      assert_not_nil notice[:error_id]
      assert_equal valid_notice_params[:message], notice[:message]
      assert_equal time, notice[:created_at]
      assert_equal time, notice[:updated_at]
    end
  end

  def test_showing_notice_for_error
    post "/v1/notices", valid_notice_params.to_json, valid_headers
    time      = Time.now.iso8601
    error_id  = last_response.payload[:error_id]
    notice_id = last_response.payload[:id]

    get  "/v1/errors/#{error_id}/notices/#{notice_id}", valid_headers
    assert_equal 200, last_response.status

    last_response.payload.tap do |notice|
      assert_not_nil notice[:id]
      assert_not_nil notice[:error_id]
      assert_equal valid_notice_params[:message], notice[:message]
      assert_equal time, notice[:created_at]
      assert_equal time, notice[:updated_at]
    end
  end
end
