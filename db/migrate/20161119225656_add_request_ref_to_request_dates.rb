class AddRequestRefToRequestDates < ActiveRecord::Migration[5.0]
  def change
    add_reference :request_dates, :request, foreign_key: true
  end
end
