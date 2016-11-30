class SpacesController < ApplicationController
  include SpacesHelper

  before_action :authenticate_user!, :except => [:index, :show]

  def index
    create_list_of_spaces
  end

  def new
    @space = Space.new
  end

  def create
    @space = Space.new(space_params)
    @space.user = current_user

    if @space.save
      (space_date_params["available_from"]..space_date_params["available_to"]).each do |date|
        SpaceDate.create(date: date, status: "open", space_id: @space.id)
      end
      redirect_to spaces_path, notice: "Space successfully added"
    else
      render "new"
    end
  end

  def show
    current_date = Time.new.strftime("%F")
    if params[:date] && params[:date] < current_date
      redirect_to spaces_path, alert: "Date cannot be in the past"
    elsif !params[:date]
      redirect_to spaces_path, alert: "Date must be choosen"
    elsif params[:date] && date_booked?
      redirect_to spaces_path, alert: "Space is not available on this date"
    else
      session[:search_date] = params[:date]
      @space = Space.find(params[:id])
      @owner = User.find(@space.user_id)
      @available_space_dates = SpaceDate.where(:space_id => params[:id], :status => "open")
    end
  end

  def edit
    @space = Space.find(params[:id])
  end

  def update
    @space = Space.find(params[:id])
    if (current_user.id == @space.user_id)
      @space.update(space_params)
      redirect_to space_path(@space), notice: "Space successfully updated"
    else
      redirect_to space_path(@space), alert: "You cannot update this space"
    end
  end

  private

  def space_params
    params.require(:space).permit(:name, :price, :description)
  end

  def space_date_params
    params.require(:space).permit(:available_from, :available_to)
  end
end
