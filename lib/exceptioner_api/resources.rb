require 'exceptioner_api/models'
require 'webmachine'

class NoticeResource < Webmachine::Resource
  def allowed_methods
    %w(GET HEAD POST)
  end
end

class ErrorResource < Webmachine::Resource
  def allowed_methods
    %w(GET HEAD)
  end
end

