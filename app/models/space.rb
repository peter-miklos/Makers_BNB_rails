class Space < ApplicationRecord
  has_many :bookings, dependent: :destroy
  has_many :requests, dependent: :destroy
  has_many :space_dates, dependent: :destroy
end
