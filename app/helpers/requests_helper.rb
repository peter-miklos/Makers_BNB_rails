module RequestsHelper

  private

  def create_new_request
    @space = Space.find(params[:space_id])
    @request = @space.requests.new(request_params)
    @request.user = current_user
    @request.status = "open"
    complete_request_creation
  end

  def complete_request_creation
    if @request.save then redirect_to my_requests_path
    else render "new"
    end
  end

  def render_new_request_view
    request = Request.where(space_id: @space.id, user_id: current_user.id)
    if (current_user && current_user.id != @space.user_id && request.empty?)
      @request = Request.new
    elsif (current_user && current_user.id != @space.user_id && !request.empty?)
      redirect_to space_path(@space), alert: "You've already created a request"
    elsif (current_user && current_user.id == @space.user_id)
      redirect_to space_path(@space), alert: "You cannot create a request for your post"
    end
  end
end
