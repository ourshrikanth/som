require 'factory_girl_rails'

FactoryGirl.define do
  factory :planned_task do |pt|
    pt.title "1gdfg"
    pt.work_hours "12"
    pt.billable_hours "11"
    pt.association :planning_sheet
  end
end