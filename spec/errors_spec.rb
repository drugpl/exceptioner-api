require "spec_helper"

resource "Errors" do
  let(:client) { @test_client }

  get "/errors" do
    example "List all errors" do
      do_request do |response|
        response.should be_ok
      end
    end
  end

  get "/errors/:id" do
    parameter :id, "Error ID"

    let(:error) { create(:error) }
    let(:id)    { error.id }

    example "Get a single error" do
      do_request do |response|
        response.should be_ok
      end
    end
  end
end
