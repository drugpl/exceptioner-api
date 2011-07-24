require 'test_helper'

class DeploysTest < Exceptioner::Api::TestCase
  def test_listing_deploys
    post "/v1/deploys", valid_deploy_params.to_json, valid_headers
    time = Time.now.iso8601

    get  "/v1/deploys", valid_headers
    assert_equal 200, last_response.status
    assert_equal 1,   last_response.payload.size

    last_response.payload.first.tap do |deploy|
      assert_not_nil deploy[:id]
      assert_equal valid_deploy_params[:environment], deploy[:environment]
      assert_equal valid_deploy_params[:repository], deploy[:repository]
      assert_equal valid_deploy_params[:revision], deploy[:revision]
      assert_equal valid_deploy_params[:author], deploy[:author]
      assert_equal time, deploy[:created_at]
      assert_equal time, deploy[:updated_at]
    end
  end

  def test_showing_deploy
    post "/v1/deploys", valid_deploy_params.to_json, valid_headers
    time      = Time.now.iso8601
    deploy_id = last_response.payload[:id]

    get  "/v1/deploys/#{deploy_id}", valid_headers
    assert_equal 200, last_response.status

    last_response.payload.tap do |deploy|
      assert_not_nil deploy[:id]
      assert_equal valid_deploy_params[:environment], deploy[:environment]
      assert_equal valid_deploy_params[:repository], deploy[:repository]
      assert_equal valid_deploy_params[:revision], deploy[:revision]
      assert_equal valid_deploy_params[:author], deploy[:author]
      assert_equal time, deploy[:created_at]
      assert_equal time, deploy[:updated_at]
    end
  end

  def test_creating_valid_deploy
    post "/v1/deploys", valid_deploy_params.to_json, valid_headers
    time = Time.now.iso8601
    assert_equal 201, last_response.status

    last_response.payload.tap do |deploy|
      assert_not_nil deploy[:id]
      assert_equal valid_deploy_params[:environment], deploy[:environment]
      assert_equal valid_deploy_params[:repository], deploy[:repository]
      assert_equal valid_deploy_params[:revision], deploy[:revision]
      assert_equal valid_deploy_params[:author], deploy[:author]
      assert_equal time, deploy[:created_at]
      assert_equal time, deploy[:updated_at]
    end
  end
end
