class Request < ApplicationRecord
  has_many :request_dates, dependent: :destroy
end
