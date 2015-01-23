class PlannedTasksController < ApplicationController
before_action :set_planning_task , only: [:show, :edit, :update, :destroy]

	
# GET /planned_tasks/new
  def new
    @planned_task = PlannedTask.new
  end

  def create
    @planned_task = PlannedTask.new(planning_task_params)

    respond_to do |format|
      if @planned_task.save
    @planning_sheet = PlanningSheet.find(@planned_task.planning_sheet_id)
    plan_hours = @planning_sheet.planned_hours + @planned_task.work_hours
    bill_hours = @planning_sheet.billable_hours + @planned_task.billable_hours
    @planning_sheet.update_attributes(planned_hours: plan_hours, billable_hours: bill_hours)
         format.json { render json: @planned_task, status: :ok }
       else
        format.json { render json: @planned_task.errors, status: :unprocessable_entity }
      end
    end
  end



#get all planned task of a corresponding planning sheet
#params : id (planning_sheet_id)
  def getAllTasksOfSheet
    order_by = JSON.parse(params[:order_by]).first rescue ["planned_tasks.id", "desc"]
    planning_sheet = PlanningSheet.joins(:user).select('users.*,planning_sheets.*').where(:id => params[:id])
		planned_tasks = PlannedTask.where(:planning_sheet_id => params[:id]).page(params[:page]).per(params[:limit]).order("#{order_by[0]} #{order_by[1]}")
		planned_tasks_count = PlannedTask.where(:planning_sheet_id => params[:id]).count

		respond_to do |format|
			format.json {render json: {data: {sheet: planning_sheet,tasks: planned_tasks},tasks_count:planned_tasks_count}}
		end
	end

  def show
    render json: @planned_task
  end
  def update
    respond_to do |format|
      if @planned_task.update(planning_task_params)
          update_plansheet_work_hours
          update_plansheet_bill_hours
        format.json { render json: true, status: :ok }
      else
        format.json { render json: false, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @planned_task.destroy
     @planning_sheet = PlanningSheet.find(@planned_task.planning_sheet_id)
    plan_hours = @planning_sheet.planned_hours - @planned_task.work_hours
    bill_hours = @planning_sheet.billable_hours - @planned_task.billable_hours
    @planning_sheet.update_attributes(planned_hours: plan_hours, billable_hours: bill_hours)
    respond_to do |format|
      format.json { render json: true }
    end
  end

private
    def set_planning_task
      @planned_task = PlannedTask.find(params[:id])
    end

    def planning_task_params
      params.require(:data).permit(:title,:work_hours,:billable_hours,:planning_sheet_id)
    end

     def update_plansheet_work_hours 
        work_hours = PlannedTask.where(planning_sheet_id: @planned_task.planning_sheet_id).sum(:work_hours)
        @planning_sheet = PlanningSheet.find(@planned_task.planning_sheet_id)
        @planning_sheet.update_attributes(planned_hours: work_hours)
    end
    def update_plansheet_bill_hours 
        bill_hours = PlannedTask.where(planning_sheet_id: @planned_task.planning_sheet_id).sum(:billable_hours)
        @planning_sheet = PlanningSheet.find(@planned_task.planning_sheet_id)
        @planning_sheet.update_attributes(billable_hours: bill_hours)
    end






end
