class AddUserRefToSpaces < ActiveRecord::Migration[5.0]
  def change
    add_reference :spaces, :user, foreign_key: true
  end
end
