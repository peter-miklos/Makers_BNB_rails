class AddSpaceRefToBookings < ActiveRecord::Migration[5.0]
  def change
    add_reference :bookings, :space, foreign_key: true
  end
end
