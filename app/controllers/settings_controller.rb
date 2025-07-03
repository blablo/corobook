class SettingsController < ApplicationController
  before_action :authenticate_user!
  before_filter :set_setting, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    if current_church.settings.first.nil?
      @setting = current_church.settings.build
    else
      @setting = current_church.settings.first
    end
    render :edit
  end

  def show
    respond_with(@setting)
  end

  def new
    redirect_to :edit
  end

  def edit
  end

  def create
    @setting = current_church.settings.build(params[:setting])
    @setting.save
    respond_with(@setting)
  end

  def update
    @setting.update_attributes(params[:setting])
    respond_with(@setting)
  end

  def destroy
    @setting.destroy
    respond_with(@setting)
  end

  private
    def set_setting
      @setting = current_church.settings.first
    end
end
