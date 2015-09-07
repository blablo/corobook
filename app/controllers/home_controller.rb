class HomeController < ApplicationController
  helper_method :resource, :resource_name, :devise_mapping
  def index
    @songs1 = Song.first(5)
    @songs2 = Song.last(5)
    if current_user and current_church
      @presentation = current_church.presentations.last
    end
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

end
