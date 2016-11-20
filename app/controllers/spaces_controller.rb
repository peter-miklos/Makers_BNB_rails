class SpacesController < ApplicationController
  include SpacesHelper

  before_action :authenticate_user!, :except => [:index, :show]

  def index
    @spaces = Space.all
  end

  def new
    @space = Space.new
  end

  def create
    @space = Space.new(space_params)
    @space.user = current_user

    if @space.save
      redirect_to spaces_path, notice: "Space successfully added"
    else
      render "new"
    end
  end

  def show
    @space = Space.find(params[:id])
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
end
