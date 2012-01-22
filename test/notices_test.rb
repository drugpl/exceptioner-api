require 'test_helper'

class NoticesTest < Exceptioner::Api::TestCase
  def test_listing_all_notices
    response = client.get notices_path
    assert_equal 200, response.code
  end

  def test_get_a_single_notice
    response = client.get notice_path, params: {id: notice.id}
    assert_equal 200, response.code
  end

  def test_create_notice_with_error
    body = {
      message: "RuntimeError: no time to run error",
      error: {
        exception: "RuntimeError",
        backtrace: "This is exception backtrace"
      }
    }

    response = client.put notices_path, body: body.to_json, headers: {"Content-Type" => "application/json"}
    assert_equal 204, response.code
  end
end
