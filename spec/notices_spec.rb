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

    let(:notice) { create(:notice) }
    let(:id)     { notice.id }

    example "Get a single notice" do
      do_request do |response|
        response.should be_ok
      end
    end
  end

  put "/notices" do
    parameter :message, "Error message"
    parameter :exception, "Error class"
    parameter :backtrace, "Error backtrace"

    scope_parameters :error, [:exception, :backtrace]

    let(:message)   { "RuntimeError: no time to run error" }
    let(:exception) { "RuntimeError" }
    let(:backtrace) { "pebkac: 123" }

    example "Create notice with error" do
      do_request do |response|
        response.status.should == 204
      end
    end
  end
end
