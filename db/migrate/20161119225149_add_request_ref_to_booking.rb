class AddRequestRefToBooking < ActiveRecord::Migration[5.0]
  def change
    add_reference :bookings, :request, foreign_key: true
  end
end
