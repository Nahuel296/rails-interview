class ApplicationController < ActionController::Base
  rescue_from ActionController::UnknownFormat, with: :raise_not_found
  protect_from_forgery with: :null_session

  def raise_not_found
    raise ActionController::RoutingError.new('Not supported format')
  end
end
