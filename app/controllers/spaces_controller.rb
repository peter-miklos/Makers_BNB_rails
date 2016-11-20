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

  private

  def space_params
    params.require(:space).permit(:name, :price, :description)
  end
end
