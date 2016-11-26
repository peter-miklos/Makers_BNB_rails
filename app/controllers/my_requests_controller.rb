class MyRequestsController < ApplicationController
  include MyRequestsHelper

  before_action :authenticate_user!

  def index
    @all_spaces = Space.all
    all_request_dates = RequestDate.all
    @my_spaces = @all_spaces.select { |space| space.user_id == current_user.id}
    my_space_ids = @my_spaces.map { |space| space.id } if @my_spaces
    @my_received_requests = Request.where(space_id: my_space_ids)
    @users_of_received_requests = User.where(id: @my_received_requests.map {|req| req.user_id })
    @all_received_request_dates = all_request_dates.select{|date| @my_received_requests.find{|req| req.id == date.request_id}}

    @my_sent_requests = Request.where(user_id: current_user.id)
    @all_sent_request_dates = all_request_dates.select{|date| @my_sent_requests.find{|req| req.id == date.request_id}}
  end
end
