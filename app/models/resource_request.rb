class ResourceRequest < ActiveRecord::Base
	
	belongs_to :user
	belongs_to :project
	has_many :requested_resources
	has_many :comments, :as => :commentable

	validates :user_id,:status,:project_id, presence: true
	validates :user_id, :project_id, numericality: { only_integer: true, greater_than: 0  }

	validates_associated :user
	validates_associated :project


	def as_json(options = {})
    json = super(options)
    json['count'] = (options[:param_for_count])
    json
end
end
