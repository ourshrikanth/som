require 'factory_girl_rails'

FactoryGirl.define do
  factory :role do
    name "Manager"
    # association :user
  end

end
