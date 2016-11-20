class SpacesController < ApplicationController
  include SpacesHelper

  def index
    @spaces = Space.all
  end
end
