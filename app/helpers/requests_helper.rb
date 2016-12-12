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

  def alert_user_unless_search_date
    unless session[:search_date]
      redirect_to space_path(@space), alert: "You cannot create a request without choosing a date" and return
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

  def update_request_statuses
    @request.update(request_status_param)
    reject_other_requests if @request.status == "accepted"
  end

  def reject_other_requests
    request_dates = get_necessary_request_dates
    set_request_statuses_to_rejected(request_dates)
  end

  def get_necessary_request_dates
    all_request_dates = RequestDate.all
    request_date = get_date_of_accepted_request(all_request_dates)
    find_request_dates_to_be_changed(request_date, all_request_dates)
  end

  def find_request_dates_to_be_changed(request_date, all_request_dates)
    open_requests = Request.where(status: "open", space_id: @space.id)
    all_request_dates = all_request_dates.select { |req_date| req_date.date == request_date }
    all_request_dates.select { |rd| open_requests.find { |req| req.id == rd.request_id } }
  end

  def get_date_of_accepted_request(all_request_dates)
    all_request_dates.find { |req_date| req_date.request_id == @request.id}.date
  end

  def set_request_statuses_to_rejected(request_dates)
    request_dates.each do |req_date|
      request = Request.find_by(id: req_date.request_id, status: "open")
      request.update(status: "rejected")
    end
  end

  def update_space_date
    space_date = SpaceDate.find_by(space_id: @space.id, date: params[:request_date].to_date, status: "open")
    space_date.update(status: "booked")
  end
end
