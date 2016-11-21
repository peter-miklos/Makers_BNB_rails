class Space < ApplicationRecord

  validates :name, presence: :true
  validates :price, presence: :true
  validates :description, presence: :true

  has_many :bookings, dependent: :destroy
  has_many :requests, dependent: :destroy
  has_many :space_dates, dependent: :destroy

  belongs_to :user

  def available_from
  end

  def available_to
  end
end
