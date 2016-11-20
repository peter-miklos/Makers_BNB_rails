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
    p params
    @space = Space.new(space_params)
    @space.user = current_user
    p @space

    if @space.save
      redirect_to spaces_path, notice: "Space successfully added"
    else
      render "new"
    end
  end

  private

  def space_params
    # params.fetch(:space, {}).permit(:name, :price, :description)
    params.require(:space).permit(:name, :price, :description)
  end
end
