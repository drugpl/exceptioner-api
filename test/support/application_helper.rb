require 'exceptioner_api/application'

module ApplicationHelper
  def app
    Exceptioner::Api::Application.new.webmachine
  end
end
