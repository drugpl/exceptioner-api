require 'factories'

module ResourcesHelper
  include FactoryGirl::Syntax::Methods

  def notice
    @notice ||= create(:notice)
  end

  def notices_path
    "/notices"
  end

  def notice_path(id = nil)
    "/notices/%s" % id || notice.id
  end

  def error
    @error ||= create(:error)
  end

  def errors_path
    "/errors"
  end

  def error_path(id = nil)
    "/errors/%s" % id || error.id
  end
end

