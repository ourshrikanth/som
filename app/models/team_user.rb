class TeamUser < ActiveRecord::Base
  PER_PAGE = 10

  belongs_to :user
  belongs_to :team
	
  validates :user_id, :team_id, presence: true
end
