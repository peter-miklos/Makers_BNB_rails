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
    if @request.save
      RequestDate.create(date: session[:search_date], request_id: @request.id)
      redirect_to my_requests_path
    else render "new"
    end
  end

  def render_new_request_view
    booked_date = get_booked_date
    @request = Request.new if (date_available_for_current_user?(booked_date))
    handle_double_booking if (date_booked_by_current_user?(booked_date))
    handle_same_ownership if (space_owned_by_current_user?)
  end

  def get_booked_date
    requests = Request.where(space_id: @space.id, user_id: current_user.id)
    request_dates = RequestDate.where(request_id: requests.map{ |req| req.id })
    return request_dates.find { |rd| rd.date == session[:search_date].to_date }
  end

  def date_available_for_current_user?(booked_date)
    current_user && current_user.id != @space.user_id && !booked_date
  end

  def date_booked_by_current_user?(booked_date)
    current_user && current_user.id != @space.user_id && booked_date
  end

  def handle_double_booking
    redirect_to(space_path(@space), alert: "You've already created a request") and return
  end

  def space_owned_by_current_user?
    current_user && current_user.id == @space.user_id
  end

  def handle_same_ownership
    redirect_to(space_path(@space), alert: "You cannot create a request for your post")
  end
end
