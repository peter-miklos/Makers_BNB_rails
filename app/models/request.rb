class Request < ApplicationRecord
  has_many :request_dates, dependent: :destroy

  belongs_to :user
  has_one :space
end
