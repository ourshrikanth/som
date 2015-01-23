require 'factory_girl_rails'
FactoryGirl.define do
  factory :allocated_resource do
   	    from_date "10-10-2014"
		to_date "10-10-2013"
		# allocated_hours "10"
		project_id 1
		user_id 1
	    # association :user,:project
    
  end

end
