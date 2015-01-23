class PlanningSheetMailer < ActionMailer::Base
  # default from: "no-reply@som.com"
  default from: "zuber.surya@softwaysolutions.net"


  def planning_sheet_submit_notification(employee, approver, plan_sheet, comment, urlpath)
    @approver = approver
    @employee = employee
    @comment = comment
    @plan_sheet = plan_sheet
    @url  = urlpath
    logger.info @approver.email
    logger.info @employee.email
    mail(to: @approver.email, subject: "[SOM] Plan Sheet for #{@plan_sheet.from_date.strftime("%d/%m/%Y")}-#{@plan_sheet.to_date.strftime("%d/%m/%Y")} #{@plan_sheet.status}", cc: Settings.developer_mails)
  end

  def planning_sheet_approved_or_rejected_notification(employee, approver, plan_sheet, comment , urlpath)
    @message = "your planning sheet has been '#{plan_sheet.status}'"
    @approver = approver
    @employee = employee
    @plan_sheet = plan_sheet
    @comment = comment
    @url  = urlpath
    mail(to: @employee.email,subject: "[SOM] Plan Sheet for #{@plan_sheet.from_date.strftime("%d/%m/%Y")}-#{@plan_sheet.to_date.strftime("%d/%m/%Y")} #{@plan_sheet.status}", cc: Settings.developer_mails)
  end

  def planning_sheet_fill_up_notification(user, urlpath, plansheet)
    #dispatches notification to all users to plan their sheet.
      @user = user
      @message = "This is to remind you to fill up your planning sheet"
      @url  = urlpath
      @plansheet = plansheet
      mail(to: user.email, subject: "[SOM] Reminder to fill your planning Sheet for #{@plansheet[0].week_no} week", cc: Settings.developer_mails )
  end

  def planning_sheet_not_submitted_nor_approved_notification(users, admin)
    @users = users
    mail(to: admin.email, subject: "Employees who has not submitted or got approval for their planning sheet.", cc: Settings.developer_mails)
  end

  def planning_sheet_final_notification(approver, team_members)
    #cron Email sending on friday afternoon
    next_week = Date.today + 1.week
    @next_week_start_date = next_week.at_beginning_of_week
    @next_week_end_date = next_week.at_end_of_week-2.days
    @team_members = team_members
    mail(to: approver.email, subject: "[SOM] Employees who has not submitted their planning sheet for next week", cc: Settings.developer_mails)
  end
end
