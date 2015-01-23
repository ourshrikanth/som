class PlanningSheet < ActiveRecord::Base

  belongs_to :user
  has_many :comments, :as => :commentable
  has_many :planned_tasks

  validates :week_no,:from_date,:to_date, :total_hours, :planned_hours, :year, :billable_hours,:user_id, presence: true
  validates :total_hours, :planned_hours, :billable_hours,  numericality: { greater_than_or_equal_to: 0  }
  validates :week_no, :year, :user_id, numericality: { only_integer: true, greater_than: 0  }
  validates_associated :user

=begin
  This function is not used anymore because we are not creating planning sheets
  through cron job.
=end
  def self.add_plan_sheet_through_cron
    @@next_week = Date.today + 1.week
    next_week_no = @@next_week.cweek.to_i
    next_week_start_date = @@next_week.at_beginning_of_week
    next_week_end_date = @@next_week.at_end_of_week-2.days
    next_week_year = @@next_week.year
    next_week_total_hours = 40
    holiday_count = 0

      (next_week_start_date..next_week_end_date).each do |date|
        # logger.info date
        if Holiday.where(holiday_date: date).present?
          # logger.info date.strftime("%A")
          if ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"].include?(date.strftime("%A"))
            # logger.info "sdf"
            holiday_count = holiday_count + 1
          end
        end
      end
    next_week_total_hours = 40 - holiday_count*8
    User.where(status: "active").ids.each do |userid|
      @nextWeekPlanSheetExists = PlanningSheet.where(:week_no => next_week_no, user_id: userid).count
      if @nextWeekPlanSheetExists == 0
        @planning_sheet = PlanningSheet.create( user_id: userid, status: 1,
              week_no: next_week_no, from_date: next_week_start_date, 
              to_date: next_week_end_date, total_hours: next_week_total_hours, planned_hours: 0, billable_hours: 0, year: next_week_year)
      end
    end
  end

  def self.planning_sheet_reminder
    #reminds users whoever not submitted timesheet.
    @@next_week = Date.today + 1.week
    next_week_no = @@next_week.cweek.to_i
    users = PlanningSheet.joins(:user).select("users.*").where("week_no = '#{next_week_no}' && users.status = 'active' && planning_sheets.status NOT IN ('submitted' , 'approved')")
    users.each do |user|
      # PlanningSheetMailer.delay.planning_sheet_fill_up_notification(user)
      plansheet = PlanningSheet.where("week_no = '#{next_week_no}' && user_id = '#{user.id}'")
      urlpath = "#{Settings.base_url}/#/planning-sheet/#{plansheet[0].id}/edit"
      PlanningSheetMailer.delay.planning_sheet_fill_up_notification(user, urlpath, plansheet)
    end
  end

  def self.planning_sheet_crossed_deadline
    #it will go to admins only on monday morning.
    present_week_no = Date.today.cweek.to_i
    userids = PlanningSheet.joins(:user).select("users.*").where("week_no = '#{present_week_no}' && users.status = 'active' && planning_sheets.status NOT IN ('submitted' , 'approved')").pluck(:user_id)
    @users = User.where(id: userids)
    @admins = User.joins(:role).where("roles.name = 'admin'")
    @admins.each do |admin|
      # PlanningSheetMailer.delay.planning_sheet_fill_up_notification(user)
      PlanningSheetMailer.delay.planning_sheet_not_submitted_nor_approved_notification(@users, admin)
    end
  end
  def self.planning_sheet_not_submitted_before_friday_evening
    #planning_sheet final reminder in friday evening.
    @@next_week = Date.today + 1.week
    next_week_no = @@next_week.cweek.to_i
    users = User.joins(:planning_sheets, :team_users).where("week_no = '#{next_week_no}' && users.status = 'active' && planning_sheets.status NOT IN ('submitted', 'approved')")
    approvers = User.joins(:teams, :team_users).where("team_users.approver = 1 && users.status = 'active'")
    approvers.each do |tl|
      tl.teams.each do |team|
        @users_in_my_team = users.where("team_users.team_id = '#{team.id}'")
          if @users_in_my_team.present?
            PlanningSheetMailer.delay.planning_sheet_final_notification(tl, @users_in_my_team)
          end
      end
    end
  end


end
