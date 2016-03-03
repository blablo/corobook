class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_church

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  def current_church
    current_user.church if current_user
  end


end
