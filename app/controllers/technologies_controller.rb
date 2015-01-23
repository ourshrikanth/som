class TechnologiesController < ApplicationController
  before_action :set_technology, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    order_by = JSON.parse(params[:order_by]).first rescue ["id", "desc"]
    filters = JSON.parse(params[:filters]) rescue []
     condition=build_condition(filters)
    @technologies = Technology.where(condition).page(params[:page]).per(params[:limit]).order("#{order_by[0]} #{order_by[1]}")
    @technologies_count = Technology.where(condition)
   render json: {data: @technologies, count: @technologies_count.count}
  end

  def build_condition(filters)
    condition = "1 = 1 "
    filters = filters.to_a
    for filter in filters
      condition << "and #{filter[0]} like '#{filter[1]}%'  "
    end
    return condition
  end

  def show
    respond_with(@technology)
  end

  def new
    @technology = Technology.new
    respond_with(@technology)
  end

  def edit
  end

  def create
    @technology = Technology.new(technology_params)
    @technology.save
    respond_with(@technology)
  end

  def update
    all_technologies = Technology.where("name=?",params[:name]).count
    if all_technologies==0
      @technology.update(name: params[:name])
      render json: {status: true, msg: ""}
    else
      render json: {status: false, msg: "Technology name already present"}
    end
  end

  def destroy
    @technology.update(status: :inactive)
    render json: @technology
  end

  def get_all
     respond_with(Technology.active)
  end

  private
    def set_technology
      @technology = Technology.find(params[:id])
    end

    def technology_params
      params.require(:technology).permit(:name)
    end
end
