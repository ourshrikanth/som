class UserSkill < ActiveRecord::Base
	validates :user_id,:technology_id, presence: true
	belongs_to :user
	belongs_to :technology
end
