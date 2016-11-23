class SpacesController < ApplicationController
  include SpacesHelper

  before_action :authenticate_user!, :except => [:index, :show]

  def index
    create_list_of_spaces
    # current_date = Time.new.strftime("%F")
    # if params[:search_date] && params[:search_date] < current_date
    #   redirect_to spaces_path, alert: "Date cannot be in the past"
    # elsif params[:search_date]
    #   space_dates = SpaceDate.where(date: params[:search_date], status: "open")
    #   space_ids = space_dates.map { |space_date| space_date.space_id }.uniq
    #   @spaces = Space.where(id: space_ids)
    #   @search_date = params[:search_date].to_date
    #   @search_date_string = params[:search_date]
    # else
    #   space_dates = SpaceDate.where(status: "open")
    #   space_dates = space_dates.select { |sd| sd.date >= current_date.to_date}
    #   space_ids = space_dates.map { |space_date| space_date.space_id }.uniq
    #   @spaces = Space.where(id: space_ids)
    #   @search_date_string = ""
    # end
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
    @space = Space.find(params[:id])
    @owner = User.find(@space.user_id)
    @available_space_dates = SpaceDate.where(:space_id => params[:id], :status => "open")
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
