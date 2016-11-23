class MyRequestsController < ApplicationController
  include MyRequestsHelper

  before_action :authenticate_user!

  def index
    @my_received_requests
    @my_spaces = Space.where(user_id: current_user.id)
    @my_sent_requests = Request.where(user_id: current_user.id)
    @all_spaces = Space.all
  end
end
