class RequestsController < ApplicationController
  include RequestsHelper

  before_action :authenticate_user!

  def index
  end

  def new
    @space = Space.find(params[:space_id])
    if session[:search_date]
      alert_user_to_use_proper_date unless search_date_available?
      execute_new_request if search_date_available?
    else
      alert_user_if_no_search_date_used
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
