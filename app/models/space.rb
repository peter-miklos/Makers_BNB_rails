class Space < ApplicationRecord
  has_many :bookings, dependent: :destroy
  has_many :requests, dependent: :destroy
end
