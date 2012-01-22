require 'test_helper'

class ErrorsTest < Exceptioner::Api::TestCase
  def test_listing_all_errors
    response = client.get errors_path
    assert_equal 200, response.code
  end

  def test_get_a_single_error
   response = client.get error_path, params: {id: error.id}
    assert_equal 200, response.code
  end
end
