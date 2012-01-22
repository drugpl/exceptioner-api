require 'exceptioner_api/models'
require 'webmachine'

module ExceptionerResource
  def content_types_provided
    [['application/json', :to_json]]
  end

  def content_types_accepted
    [['application/json', :from_json]]
  end
end

class NoticeCollectionResource < Webmachine::Resource
  include ExceptionerResource

  def allowed_methods
    %w[GET HEAD PUT]
  end

  def to_json
    @notices = Notice.all
    @notices.to_json
  end

  def from_json
    params = JSON.parse(request.body.to_s)
    Notice.create(params)
  end
end

class NoticeResource < Webmachine::Resource
  include ExceptionerResource

  def resource_exists?
    @notice = Notice.first(conditions: {_id: request.path_info[:id]})
    @notice.present?
  end

  def to_json
    @notice.to_json
  end
end

class ErrorResource < Webmachine::Resource
  include ExceptionerResource

  def resource_exists?
    @error = Error.first(conditions: {_id: request.path_info[:id]})
    @error.present?
  end

  def to_json
    @error.to_json
  end
end

class ErrorCollectionResource < Webmachine::Resource
  include ExceptionerResource

  def to_json
    @notices = Error.all
    @notices.to_json
  end
end

