class Space < ApplicationRecord
  has_many :bookings, dependent: :destroy
end
