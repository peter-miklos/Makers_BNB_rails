module SpacesHelper

  def create_list_of_spaces
    current_date = Time.new.strftime("%F")
    if wrong_date_searched?(current_date)
      redirect_to spaces_path, alert: "Date cannot be in the past"
    elsif search_date_used? then show_spaces_on_date
    else show_all_spaces(current_date)
    end
  end

  private

  def wrong_date_searched?(current_date)
    params[:search_date] && params[:search_date] < current_date
  end

  def search_date_used?
    (params[:search_date] || session[:search_date]) && !params[:filter]
  end

  def show_spaces_on_date
    search_date = params[:search_date] ? params[:search_date] : session[:search_date]
    space_dates = SpaceDate.where(date: search_date, status: "open")
    show_spaces(space_dates)
    @search_date = search_date
    session[:search_date] = search_date
  end

  def show_all_spaces(current_date)
    session[:search_date] = nil
    space_dates = SpaceDate.where(status: "open")
    space_dates = space_dates.select { |sd| sd.date >= current_date.to_date}
    show_spaces(space_dates)
  end

  def show_spaces(space_dates)
    space_ids = space_dates.map { |space_date| space_date.space_id }.uniq
    @spaces = Space.where(id: space_ids)
  end
end
