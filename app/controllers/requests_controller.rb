class RequestsController < ApplicationController
  include RequestsHelper

  before_action :authenticate_user!

  def index
  end

  def new
    @space = Space.find(params[:space_id])
    request = Request.where(space_id: @space.id, user_id: current_user.id)
    if (current_user && current_user.id != @space.user_id && !request)
      @request = Request.new
    elsif (current_user && current_user.id != @space.user_id && request)
      redirect_to space_path(@space), alert: "You've already created a request"
    elsif (current_user && current_user.id == @space.user_id)
      redirect_to space_path(@space), alert: "You cannot create a request for your post"
    end
  end
end
