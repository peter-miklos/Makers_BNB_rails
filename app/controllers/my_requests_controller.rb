class MyRequestsController < ApplicationController
  include MyRequestsHelper

  before_action :authenticate_user!

  def index
    @all_spaces = Space.all
    @my_spaces = @all_spaces.select { |space| space.user_id == current_user.id}
    my_space_ids = @my_spaces.map { |space| space.id } if @my_spaces
    @my_received_requests = Request.where(space_id: my_space_ids)
    @my_sent_requests = Request.where(user_id: current_user.id)
  end
end
