class PlanningSheetsController < ApplicationController
  include ApplicationHelper
  # get all planning sheets belonging to a user
  #params : user_id, page (page number)
  # return data in json format

  # get all planning sheets of a logged in user
    def index
      order_by = JSON.parse(params[:order_by]).first rescue ["planning_sheets.id", "desc"]
      condition = build_condition(JSON.parse(params[:filters]))
      @planning_sheets = PlanningSheet.where(:user_id => current_user.id).where(condition).page(params[:page]).per(params[:limit].to_i).order("#{order_by[0]} #{order_by[1]}")
      @planning_sheets_count = PlanningSheet.where(:user_id => current_user.id).where(condition).count
      respond_to do |format|
         format.json { render json: {data: @planning_sheets, count: @planning_sheets_count} }
      end
    end

     def build_condition(filters)
          condition = "planning_sheets.id != 0 "
          filters = filters.to_a
          for filter in filters
            if filter[0]=='week'
            condition << "and #{filter[0]} = '#{filter[1]}' "
              else
            condition << "and #{filter[0]} like '#{filter[1]}%' "
            end
          end
          return condition
        end
    
    def new
      @planning_sheet = PlanningSheet.new
      respond_to do |format|
         format.json { render json: @planning_sheet }
      end
    end
    def create
      @planning_sheet = PlanningSheet.new(planning_sheet_params)
      @planning_sheet.user_id = current_user.id
      @planning_sheet.save
      respond_to do |format|
         format.json { render json: @planning_sheet }
      end
    end

  # GET /planning_sheets/1
  # GET /planning_sheets/1.json
  def show
    render json: PlanningSheet.find(params[:id])
  end
  def add_sheet
    @@next_week = Date.today + 1.week
    next_week_no = @@next_week.cweek.to_i
    next_week_start_date = @@next_week.at_beginning_of_week
    next_week_end_date = @@next_week.at_end_of_week-2.days
    next_week_year = @@next_week.year
    next_week_total_hours = 40
    holiday_count = 0

      (next_week_start_date..next_week_end_date).each do |date|
        if Holiday.where(holiday_date: date).present?
          if ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"].include?(date.strftime("%A"))
            holiday_count = holiday_count + 1
          end
        end
      end
    next_week_total_hours = 40 - holiday_count*8
    @nextWeekPlanSheetExists = PlanningSheet.where(week_no: next_week_no, user_id: current_user.id).count
    if @nextWeekPlanSheetExists == 0
      @planning_sheet = PlanningSheet.create( user_id: current_user.id, status: 1,
            week_no: next_week_no, from_date: next_week_start_date,
            to_date: next_week_end_date, total_hours: next_week_total_hours, planned_hours: 0, billable_hours: 0, year: next_week_year)
          if !@planning_sheet.nil?
            puts "planning sheet for next week created"
            render nothing: true
            # redirect_to :root
          else
            puts "something went wrong, please try again after some time"
            render nothing: true
            # redirect_to :root
          end
    else
      puts "planning sheet for next week already exists."
      render nothing: true
      # redirect_to :root
    end
  end
private
    def planning_sheet_params
      params.require(:planning_sheet).permit(:status, :week_no, :year, :from_date, :to_date ,:total_hours ,:planned_hours ,:billable_hours ,:user_id )
    end

end
