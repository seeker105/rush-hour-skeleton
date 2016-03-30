class Referrer < ActiveRecord::Base
  has_many :payload_requests
  has_many :urls, through: :payload_requests

  validates :address, presence: true
end
