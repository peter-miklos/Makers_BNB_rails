module SpacesHelper

  def create_list_of_spaces
    current_date = Time.new.strftime("%F")
    spaces = Space.all
    space_dates = SpaceDate.where("date >= ?", current_date)
    space_dates = space_dates.select {|s| s.status == "open" }
    search_date = session[:search_date] ? session[:search_date] : current_date
    render component: 'Spaces', props: { spaces: spaces, search_date: search_date, space_dates: space_dates }, class: 'spaces'
  end

  private

  def date_booked?
    space_date = SpaceDate.find_by(date: params[:date].to_date, space_id: params[:id], status: "open")
    !space_date
  end
end
