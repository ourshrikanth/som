require 'factory_girl_rails'

FactoryGirl.define do
  factory :comment do |pt|
    pt.comment "hi ............"
    pt.planning_sheet_id "2"
    pt.user_id "2"
    # pt.association :planning_sheet
    # pt.association :user
  end
end