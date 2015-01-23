# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# 100.times do |i|
#   Role.create(name: "Role ##{i}")
# end
[4,21].each do |user_id| 
(40..52).each do |i|
	PlanningSheet.create(week_no: 2,year: "2015",to_date:"2014-1-5",from_date:"2014-1-9",total_hours: 40,planned_hours: 40,billable_hours: 40,user_id: 78,status: "draft")
end
end

(1..20).each do |sheet_id|
(1..5).each do |i|
	PlannedTask.create(title:"task ##{i}",work_hours: 40,billable_hours: 40,planning_sheet_id: sheet_id.to_i)
end
end

