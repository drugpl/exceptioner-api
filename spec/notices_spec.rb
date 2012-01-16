require "spec_helper"

resource "Notice" do
  let(:client) { @test_client }

  get "/notices" do
    example "List all notices" do
      do_request do |response|
        response.should be_ok
      end
    end
  end

  get "/notices/:id" do
    parameter :id, "Notice ID"

    let(:id) { 1 }

    example "Get a single notice" do
      do_request do |response|
        response.should be_ok
      end
    end
  end

  post "/notices" do
    parameter :message, "Error message"
    parameter :exception, "Error class"
    parameter :backtrace, "Error backtrace"

    scope_parameters :error, [:exception, :backtrace]

    example "Create notice with error" do
      do_request do |response|
        response.should be_ok
      end
    end
  end
end
