class AddSpaceRefToRequests < ActiveRecord::Migration[5.0]
  def change
    add_reference :requests, :space, foreign_key: true
  end
end
