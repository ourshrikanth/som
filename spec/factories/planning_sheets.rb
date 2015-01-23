require 'factory_girl_rails'

FactoryGirl.define do
  factory :planning_sheet do |ps|
    ps.status "submitted"
    ps.week_no "7"
    ps.from_date "11-2-2014"
    ps.to_date "18-2-2014"
    ps.total_hours "40"
    ps.planned_hours "12"
    ps.year "2014"
    ps.billable_hours "1"
    ps.user_id 1
  end
end
