class Department < ActiveRecord::Base
has_many :teams
after_update :inactivate_teams

validates :name, presence: true, uniqueness: { case_sensitive: false }
validates_associated :teams

scope :active, -> {where(status: 'active')}

 def as_json(options={})
	super(options.merge(include: :teams))
 end


  def inactivate_teams
  	if status == :inactive
   		teams.update_all(status: :inactive)
   		teams.each do |team|
   			team.reload.inactivate_users
   		end
	end
  end



end
