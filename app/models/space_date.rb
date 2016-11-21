class SpaceDate < ApplicationRecord
  validates :date, presence: :true
  validates :status, presence: :true
end
