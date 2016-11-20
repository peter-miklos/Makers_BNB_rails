class SpacesController < ApplicationController
  include SpacesHelper

  before_action :authenticate_user!, :except => [:index, :show]

  def index
    @spaces = Space.all
  end

  def new
    @space = Space.new
  end
end
