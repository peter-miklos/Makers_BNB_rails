class RequestsController < ApplicationController
  include RequestsHelper

  before_action :authenticate_user!

  def index
  end

  def new
    @space = Space.find(params[:space_id])
    @owner = User.find(@space.user_id)
    @request_date = session[:sds]
    request = Request.where(space_id: @space.id, user_id: current_user.id)
    if (current_user && current_user.id != @space.user_id && request.empty?)
      @request = Request.new
    elsif (current_user && current_user.id != @space.user_id && !request.empty?)
      redirect_to space_path(@space), alert: "You've already created a request"
    elsif (current_user && current_user.id == @space.user_id)
      redirect_to space_path(@space), alert: "You cannot create a request for your post"
    end
  end

  def create
    @space = Space.find(params[:space_id])
    @request = @space.requests.new(request_params)
    @request.user = current_user

    if @request.save
      redirect_to space_path(@space)
    else
      render "new"
    end
  end

  private

  def request_params
    params.require(:request).permit(:message)
  end
end
