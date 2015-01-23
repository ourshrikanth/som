class ResourceRequestsController < ApplicationController
  def index
  	order_by = JSON.parse(params[:order_by]).first rescue ["resource_requests.id", "desc"]
  	filters = JSON.parse(params[:filters])
  	condition = build_condition(filters)
  	result = query_data(condition,order_by)
    requests_resources = result.page(params[:page]).per(params[:limit])
    render json: requests_resources.to_json(:param_for_count => result.count,:include => [:user,:project,:requested_resources => {:include => [:user =>{:except => [ :created_at, :updated_at ]} ]}])
  end

  def query_data(condition,order_by)
  	 if current_user.role.name == "project manager"
      requests_resources=current_user.resource_requests.joins(:project).where(condition).order("#{order_by[0]} #{order_by[1]}")
    else
      requests_resources = ResourceRequest.joins(:project,:user).where(condition).order("#{order_by[0]} #{order_by[1]}")
 	 end
  end

 
  def build_condition(filters)
    condition = "resource_requests.id !=0 "
    filters = filters.to_a
    for filter in filters
      condition << "and #{filter[0]} like '#{filter[1]}%'  "
    end
    return condition
  end

  def create
    if params[:newUsers] && params[:newUsers].present?
    resource_request = ResourceRequest.create!(resource_request_params)
    if resource_request.save
      comments = resource_request.comments.create(comment_params)
      users = params[:newUsers]
      for user in users
        resource_request.requested_resources.create(user_id: user[:user_id],start_date: user[:dateRange][:startDate],end_date: user[:dateRange][:endDate],hours: user[:hours])
      end

        ResourceMailer.delay.ResourceRequestsAndReply(current_user, resource_request, comments)
        render json: {status: true, msg: "Request is successful"}
    else
      render json: {status: false, msg: "Request is unsuccessful. Please try again!"}
    end
    else
      render json: {status: false, msg: "Request is unsuccessful. Please try again!"}
    end
  end

  def update_record
    if params[:status]=='approve'
      status = "approved"
    else params[:status]=='reject'
      status = "rejected"
    end
    @resource_request = ResourceRequest.find(params[:id].to_i)
       if @comments = @resource_request.comments.create(comment_params)
        if @resource_request.update_attributes(status: status)
          # @resource_request.reload!
          logger.info "--------------------------------#{@resource_request}---------------------------------"
          ResourceMailer.delay.ResourceRequestsAndReply(current_user, @resource_request, @comments)
          render json: true
        else
           render json: false
        end
       end
  end

  private
  def resource_request_params
    params[:user_id] = current_user.id
    params.permit(:project_id,:user_id)
  end
  def comment_params
    params[:comment][:user_id] = current_user.id
    params.require(:comment).permit(:comment, :user_id)
  end
  
# Parameters: {"id"=>"3", "status"=>"reject", "comment"=>{"comment"=>"aaaaaaaaaaaaaa"}, "team_user"=>{"id"=>"3"}}


end
