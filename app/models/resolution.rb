class Resolution < ActiveRecord::Base
  has_many :payload_requests

  validates :width, presence: true, uniqueness: true
  validates :height, presence: true, uniqueness: true

  def self.resolutions_across_all_requests
   result =  pluck(:width, :height)
   result.map do |n|
     "#{n[0]} X #{n[1]}"
    end
  end
end
