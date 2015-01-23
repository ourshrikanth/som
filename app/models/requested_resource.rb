class RequestedResource < ActiveRecord::Base
	belongs_to :resource_requests
	belongs_to :user

	validates :start_date,:end_date,:hours,:resource_request_id,:user_id, presence: true
	validates :resource_request_id, :user_id, numericality: { only_integer: true, greater_than: 0  }



end
