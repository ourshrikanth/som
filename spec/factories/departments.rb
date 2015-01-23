require 'factory_girl_rails'

FactoryGirl.define do
  factory :department do |dept|
    dept.name "WEB"
    dept.status "active"
  end
end