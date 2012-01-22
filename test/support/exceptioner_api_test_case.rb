require 'support/test_client'
require 'support/application_helper'
require 'support/resources_helper'
require 'support/database_helper'

class Exceptioner::Api::TestCase < MiniTest::Unit::TestCase
  include ApplicationHelper
  include ResourcesHelper
  include DatabaseHelper

  attr_reader :client

  def setup
    @client = TestClient.new(app)
  end
end

