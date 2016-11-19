class AddSpaceRefToSpaceDates < ActiveRecord::Migration[5.0]
  def change
    add_reference :space_dates, :space, foreign_key: true
  end
end
