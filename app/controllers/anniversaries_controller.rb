class AnniversariesController < ApplicationController
  before_filter :set_anniversary, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @anniversaries = current_church.anniversaries.order(:date)
    respond_with(@anniversaries)
  end

  def show
    respond_with(@anniversary)
  end

  def new
    @anniversary = current_church.anniversaries.build
    respond_with(@anniversary)
  end

  def edit
  end

  def create
    @anniversary = current_church.anniversaries.build(params[:anniversary])
    @anniversary.save
    respond_with(@anniversary, :location => anniversaries_url)
  end

  def update
    @anniversary.update_attributes(params[:anniversary])
    respond_with(@anniversary, :location => anniversaries_url)
  end

  def destroy
    @anniversary.destroy
    respond_with(@anniversary)
  end

  private
    def set_anniversary
      @anniversary = current_church.anniversaries.find(params[:id])
    end
end
