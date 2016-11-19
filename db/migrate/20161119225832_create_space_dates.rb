class CreateSpaceDates < ActiveRecord::Migration[5.0]
  def change
    create_table :space_dates do |t|
      t.date :date
      t.string :status

      t.timestamps
    end
  end
end
