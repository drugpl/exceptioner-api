require "spec_helper"

resource "Errors" do
  get "/errors" do
    example "List all errors" do
      do_request
    end
  end

  get "/errors/:id" do
    parameter :id, "Error ID"

    let(:error) { OpenStruct.new(id: 1) }
    let(:id) { error.id }

    example "Get a single error" do
      do_request
    end
  end
end
