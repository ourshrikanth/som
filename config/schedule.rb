# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :environment => 'development'
# set :output, {:error => 'log/error-.log', :standard => 'log/cron.log'}

every :monday, :at => '2pm' do
# every 1.minutes do
  runner "PlanningSheet.add_plan_sheet_through_cron"
end
every :friday, :at => '9am' do
# every 1.minutes do
  runner "PlanningSheet.planning_sheet_reminder"
end
every :friday, :at => '5pm' do
# every 1.minutes do
  runner "PlanningSheet.planning_sheet_not_submitted_before_friday_evening"
end
every :monday, :at => '10am' do
# every 1.minutes do
  runner "PlanningSheet.planning_sheet_crossed_deadline"
end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
