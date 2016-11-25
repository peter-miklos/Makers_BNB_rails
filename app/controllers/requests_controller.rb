class RequestsController < ApplicationController
  include RequestsHelper

  before_action :authenticate_user!

  def index
  end

  def new
    @space = Space.find(params[:space_id])
    if session[:search_date]
      @owner = User.find(@space.user_id)
      @request_date = session[:search_date]
      render_new_request_view
    else
      redirect_to space_path(@space), alert: "You cannot create a request without choosing a date" and return
    end
  end

  def create
    create_new_request
  end

  private

  def request_params
    params.require(:request).permit(:message)
  end
end
