require 'factory_girl_rails'
FactoryGirl.define do
  factory :user do |u|
    u.first_name "Jona"
    u.last_name "Smith"
    u.email "test@example.com"
    u.password "123456"
    u.password_confirmation "123456"
    u.employee_id "123456"
    u.role_id "1"
  end
end
