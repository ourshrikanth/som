class Project < ActiveRecord::Base
	validates :user_id,:name, presence: true
	validates :name, uniqueness: { case_sensitive: false }
	validates :user_id, numericality: { only_integer: true }
	has_many :allocated_resources
	has_many :resource_requests
	has_many :requested_resources, through: :resource_requests
	belongs_to :user
end
