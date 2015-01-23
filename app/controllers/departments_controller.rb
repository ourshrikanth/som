class DepartmentsController < ApplicationController
  before_action :set_department, only: [:show, :edit, :update, :destroy]
  

  # GET /departments
  # GET /departments.json
  def index
    @departments = Department.all
    respond_to do |format|
      format.json{ render json: @departments}
    end
  end

  # GET /departments/1
  # GET /departments/1.json
  def show
    render json: @department
  end

  # GET /departments/new
  def new
    @department = Department.new
  end

  # GET /departments/1/edit
  def edit
  end

  # POST /departments
  # POST /departments.json
  def create
    @department = Department.new(department_params)

    respond_to do |format|
      if @department.save
        format.html { redirect_to @department, notice: 'Department was successfully created.' }
        format.json { render json: @department }
      else
        format.html { render :new }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /departments/1
  # PATCH/PUT /departments/1.json
  def update
     all_departments = Department.where("name=?",params[:name]).count
    if all_departments==0
      @department.update(name: params[:name])
      render json: {status: true, msg: ""}
    else
      render json: {status: false, msg: "Department name already present"}
    end
  end

  # DELETE /departments/1
  # DELETE /departments/1.json
  def destroy
    @department.update(status: :inactive)
    render json: @department
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_department
    @department = Department.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def department_params
    params[:department].permit(:name,:status)
  end
end
