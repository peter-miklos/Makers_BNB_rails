class RequestsController < ApplicationController
  include RequestsHelper

  before_action :authenticate_user!

  def index
  end

  def new
    @space = Space.find(params[:space_id])
    alert_user_unless_search_date
    if session[:search_date]
      space_date = SpaceDate.find_by(date: session[:search_date], status: "open")
      if !space_date
        redirect_to space_path(@space), alert: "Space is not available on this date" and return
      else
        @owner = User.find(@space.user_id)
        @request_date = session[:search_date]
        render_new_request_view
      end
    end
  end

  def create
    create_new_request
  end

  def update
    @space = Space.find(params[:space_id])
    @request = Request.find(params[:id])
    update_request_statuses
    update_space_date
    redirect_to my_requests_path
  end

  private

  def request_params
    params.require(:request).permit(:message, :status)
  end

  def request_status_param
    params.permit(:status)
  end
end
