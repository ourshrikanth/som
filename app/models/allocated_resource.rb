class AllocatedResource < ActiveRecord::Base
	validates :from_date, :to_date, :project_id, :user_id, presence: true
	belongs_to :user
	belongs_to :project
end
