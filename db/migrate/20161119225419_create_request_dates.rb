class CreateRequestDates < ActiveRecord::Migration[5.0]
  def change
    create_table :request_dates do |t|
      t.date :date

      t.timestamps
    end
  end
end
