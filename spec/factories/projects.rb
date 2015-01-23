require 'factory_girl_rails'

FactoryGirl.define do 
	factory :project do
		user_id 1
		name "thorovet"
		association :user
	end
end