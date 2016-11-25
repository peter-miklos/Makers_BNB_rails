class RequestsController < ApplicationController
  include RequestsHelper

  before_action :authenticate_user!

  def index
  end

  def new
    @space = Space.find(params[:space_id])
    @owner = User.find(@space.user_id)
    @request_date = session[:search_date]
    render_new_request_view
  end

  def create
    create_new_request
  end

  private

  def request_params
    params.require(:request).permit(:message)
  end
end
