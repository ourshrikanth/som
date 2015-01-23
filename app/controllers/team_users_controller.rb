class TeamUsersController < ApplicationController
  include ApplicationHelper

  def index
    @team_users = TeamUser.where(user_id: current_user.id,approver: 1).page(params[:page]).per(TeamUser::PER_PAGE)
    @team_users = @team_users.to_json(include: { team: { include: { users: { only: [:id, :first_name, :last_name, :employee_id, :role_id, :email] } } } })
    render json: @team_users
  end

  def all_users_planning_sheets
     order_by = params[:order_by].first rescue ["planning_sheets.id", "desc"]
      condition = build_condition(params[:filters])
      @users_plansheets = PlanningSheet.joins(user: :team_users).select('users.*,planning_sheets.*').where(condition).page(params[:page]).per(params[:limit]).order("#{order_by[0]} #{order_by[1]}")
      # @users_plansheets = @users_plansheets.to_json(include: :user)
      users_plansheets_count = PlanningSheet.joins(user: :team_users).where(condition).count
    render json:{data: @users_plansheets, count:users_plansheets_count } 
  end
 
 #get all users planning sheets of a team
 #params : team_id, filters, order_by
 #manager to review his team members planning sheet
  def users_planning_sheet
    if params[:team_id].present?
      order_by = params[:order_by].first rescue ["planning_sheets.id", "desc"]
      condition = build_condition(params[:filters])
      @users_plansheets = PlanningSheet.joins(user: :team_users).select('users.*,planning_sheets.*').where(condition).where(team_users: { team_id: params[:team_id] }).where.not(user_id: current_user.id).page(params[:page]).per(params[:limit]).order("#{order_by[0]} #{order_by[1]}")
      # @users_plansheets = @users_plansheets.to_json(include: :user)
      users_plansheets_count = PlanningSheet.joins(user: :team_users).where(condition).where(team_users: { team_id: params[:team_id] }).where.not(user_id: current_user.id).count
      render json:{data: @users_plansheets, count:users_plansheets_count }
    else
      render nothing: true
    end
  end

  def isUserReviewer
    isOwner = TeamUser.where(:team_id=>params[:team_id],:approver=>true,:user_id=>current_user.id).exists?
    render json: isOwner
  end

  def isSheetBelongsToTeam
    @sheet = PlanningSheet.where(:id=>params[:sheet_id]).select(:user_id).first
    # check first sheet is present or not. 
    if @sheet.present?
      # if logged in user is admin, allow him
      if params[:role]=="admin"
      render json: true
      else
      # get all teams managing by user
      teams = TeamUser.where("user_id=#{current_user.id} and approver=1").pluck(:team_id)
      # get all team users managing by user
      @team_users = TeamUser.where(:team_id => teams).pluck(:user_id)
       # if planning sheet user_id is present in array, allow him. 
        if @team_users.include?@sheet.user_id
        render json: true
        else
        render json: false
        end
      end
    else
      # planning sheet doesnt not exits. 
      render json: false
    end
    
  end

  def build_condition(filters)
          condition = "planning_sheets.user_id!=#{current_user.id} "
          filters = filters.to_a
          for filter in filters
            if filter[0]=='year'
            condition << "and #{filter[0]} = '#{filter[1]}'"
              else
            condition << "and #{filter[0]} like '#{filter[1]}%'"
            end
          end
          return condition
        end
  def user_planning_sheet_detail
    # raise params.inspect
    order_by = params[:data][:order_by].first rescue ["planned_tasks.id", "desc"]
    @planning_sheet = PlanningSheet.includes(:planned_tasks).where.not(:user_id => current_user.id).where(id: params[:planning_sheet_id]).page(params[:page]).per(params[:limit]).order("#{order_by[0]} #{order_by[1]}")
    @planning_sheet = @planning_sheet.to_json({include: [:user, :planned_tasks]})
    render json: @planning_sheet
  end

  def update_planning_sheet
    if params[:comment].present?
       # @comment = Comment.new(comment_params)
       # @comment.planning_sheet_id = params[:id].to_i
       # @comment.user_id = current_user.id
       # @comment.save!
    end
   if params[:status]=='approve'
    status = "approved"
  elsif params[:status]=='reject'
    status = "rejected"
  else
    status = "submitted"
  end
   # status = "submitted"
    @planning_sheet = PlanningSheet.find(params[:id].to_i)
    logger.info comment_params
    @planning_sheet.comments.create(comment_params)
      if @planning_sheet.update_attributes(status: status)
        base_url = request.protocol + request.host_with_port
        if (@planning_sheet.user_id == current_user.id)
            #this is when employee changes the status, mail will go to approver
            urlpath = "#{base_url}/#/userplansheet/#{@planning_sheet.id}"
            @employee = User.includes(:team_users, :teams).find(current_user.id)
            @employee.teams.each do |team|
              team_user_approver = TeamUser.where(team_id: team.id, approver: 1)
              team_user_approver.each do |approver|
                @approver = User.find(approver.user_id)
                PlanningSheetMailer.delay.planning_sheet_submit_notification(@employee, @approver, @planning_sheet, @comment, urlpath)
              end
            end
        else
            #this is when approver changes the status, mail will go to employee
            urlpath = "#{base_url}/#/planning-sheet/#{@planning_sheet.id}/edit"
            @approver = User.find(current_user.id)
            @employee = User.find(@planning_sheet.user_id)
            PlanningSheetMailer.delay.planning_sheet_approved_or_rejected_notification(@employee, @approver, @planning_sheet, @comment, urlpath)
        end
         render json: @planning_sheet
      else
         render :json => false
       end
  end

 private
    # Use callbacks to share common setup or constraints between actions.
    def comment_params
      params[:comment][:user_id] = current_user.id
      params.require(:comment).permit(:comment, :user_id)
    end
end
