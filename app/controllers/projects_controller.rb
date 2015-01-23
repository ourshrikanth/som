class ProjectsController < ApplicationController
	before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    order_by = JSON.parse(params[:order_by]).first rescue ["id", "desc"]
    logger.info order_by
    filters = JSON.parse(params[:filters]) rescue []
     condition=build_condition(filters)
    @projects = Project.where(condition).page(params[:page]).per(params[:limit]).order("#{order_by[0]} #{order_by[1]}")
    @project_count = Project.where(condition)
   render json: {data: @projects, count: @project_count.count}
  end

  def build_condition(filters)
    condition = "projects.id !=0 "
    filters = filters.to_a
    for filter in filters
      condition << "and #{filter[0]} like '#{filter[1]}%'  "
    end
    return condition
  end

     def show
    respond_with(@project)
  end

  def new
    @project = Project.new
    respond_with(@project)
  end

  def edit
  end

  def create
    @project = Project.new(project_params)
    @project.save
    respond_with(@project)
  end

  def destroy
    @project.update(status: :inactive)
    render json: @project
  end

  def update
    projects = Project.where("name=?",params[:name]).count
    if projects==0
      @project.update(name: params[:name])
      render json: {status: true, msg: ""}
    else
      render json: {status: false, msg: "Project name already present"}
    end
  end

  private
    def set_project
      @project = Project.find(params[:id])
    end

    def project_params
      params.require(:project).permit(:name,:user_id)
    end
end
