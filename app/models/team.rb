class Team < ActiveRecord::Base
  belongs_to :department
  has_many :team_users
  has_many :users, through: :team_users
  after_update :inactivate_users
	
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :department_id, presence: true

  scope :active, -> {where(status: 'active')}

  def inactivate_users
    if status.to_s == "inactive"
      team_users.destroy_all
    end
  end


end

