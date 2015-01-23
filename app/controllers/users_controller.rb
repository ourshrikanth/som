class UsersController < ApplicationController
  # before_action :set_user, only: [:show, :edit, :update, :destroy]
  # GET /user/1
  # GET /user/1.json

 
 def index
    order_by = JSON.parse(params[:order_by]).first rescue ["users.id", "desc"]
    filters = JSON.parse(params[:filters])
    condition=build_condition(filters)
    @users = get_index_data(condition,order_by).
	page(params[:page]).per(params[:limit])
    user_count = get_index_data(condition,order_by).length
    render json: {data: @users, count: user_count}
  end

  def build_condition(filters)
    condition = "1 = 1 " 
    filters = filters.to_a
    for filter in filters
      if filter[1] && !filter[1].blank?
        if filter[1].class == Array 
          if arr=filter[1].reject(&:blank?).count > 0 
          condition << "and #{filter[0]} in (#{filter[1].join(",")})  "
        end
        else
      		condition << "and #{filter[0]} like '#{filter[1]}%'  "
        end
   		 end
    end
    return condition
  end

  def get_index_data(condition,order_by)
  	return User.joins(:role).
    joins("LEFT OUTER JOIN team_users ON team_users.user_id = users.id").
    joins("LEFT OUTER JOIN teams ON team_users.team_id = teams.id").
    joins("LEFT OUTER JOIN user_skills ON user_skills.user_id = users.id").
    joins("LEFT OUTER JOIN technologies ON user_skills.technology_id = technologies.id").
	where(condition).
	select("users.*,roles.name as role_name, GROUP_CONCAT(DISTINCT(teams.name) SEPARATOR ', ') as team_name,users.id as id, GROUP_CONCAT(DISTINCT(technologies.name) SEPARATOR ', ') as technology_name").
	group("users.id").order("#{order_by[0]} #{order_by[1]}")
  end

  def show
    render json: User.find(params[:id]).to_json(include: [:role,:technologies,:teams,:team_users])
  end

  # params : user_id
  def getMyRole
    user = User.find(params[:user_id])
    if user.role.name.downcase!= "admin" && user.role.name.downcase!='project manager'
      if user.team_users.where(approver: true).exists?
        user.role.name  ="reporting manager"
      else
        user.role.name  ="employee"
      end
    end
    render json: {role_name: user.role.name}
  end


  def checkUniqueFields
    # logger.info params
    if params[:user_id].to_i == 0
      data = (params[:model].constantize).where("#{params[:property]} = ?" ,params[:value]).select(:id)
    else
      data = (params[:model].constantize).where("#{params[:property]} = ? and id!= ?" ,params[:value],params[:user_id].to_i).select(:id)
    end
    if data.exists?
      logger.info "exists"
      render json: false
    else
      render json: true
      logger.info "doesnt exists"

    end
				   
  end
  # get all users of a team
  def getAllUsersOfTeam
    users= Team.joins(:users,:team_users).
    joins("LEFT OUTER JOIN user_skills ON user_skills.user_id = users.id").
    joins("LEFT OUTER JOIN technologies ON user_skills.technology_id = technologies.id").
    where("teams.id=?",params[:team_id]).page(params[:page]).per(params[:limit]).
    order(id: :desc).select("teams.*,users.*,team_users.*,users.status as user_status, GROUP_CONCAT(DISTINCT(technologies.name) SEPARATOR ', ') as technology_name").group("users.id")
    render json: {data: users,count:  users.length, team_id: params[:team_id]}

  end

  def save
    user=User.new(registration_params)
    new_user_password = user.password
    if user.save
      teams=params[:newTeams]
      technologies = params[:technologies]
      if teams && teams.present?
      	for team in teams
        	team_user = user.team_users.build(team_id: team["team_id"],approver: team["approver"])
        	team_user.save
      	end
      end
      if technologies && technologies.present?
     		for technology in  technologies
        		user_skills = user.user_skills.build(technology_id: technology)
        		user_skills.save
      		end
   	 end
      urlpath = request.protocol+request.host_with_port
      UserMailer.delay.welcome_user(user, current_user, urlpath, new_user_password)
      render text: "#{user.full_name} User Created Successfully"
    else
      render text: "User Creation Failed"
    end
  end

  def update
    user=User.find(params[:id])
    user.update(registration_params)
   teams=params[:newTeams]
    technologies = params[:technologies]
    if teams && teams.present?
      user.team_users.destroy_all
      for team in teams
        team_user = user.team_users.build(team_id: team["team_id"],approver: team["approver"])
        team_user.save
      end
    end
    if technologies && technologies.present?
      user.technologies.destroy_all
      for technology in  technologies
        user_skills = user.user_skills.build(technology_id: technology)
        user_skills.save
      end
    end    
    render text: true
  end

  def destroy
    User.find(params[:id]).update_attributes(status: :inactive)
    user = User.find(params[:id])
    UserMailer.delay.deactivation_confirmation(user, current_user)
    render text: true
  end

  def edit
    render json: User.find(params[:id]).to_json(:include => {:technologies => {:only=> [:name,:id]}} )
  end

  def update_profile
    user = User.find(params[:id])
    technologies = params[:technologies]
    
    if ( !params[:current_password] || !params[:password] || !params[:confirm_password] ) && ( params[:current_password] || params[:password] || params[:confirm_password])
      render json: {status: "password_missing"} and return 
    end 
    
    if (params[:current_password] && params[:password] && params[:confirm_password])
      if !(user.valid_password?(params[:current_password]))
        render json: {status: false} and return 
      end
      if user.update_with_password(registration_params)
        sign_in user, :bypass => true
      end
    end
    
    if user && user.present?
        user.update_attributes(first_name: params[:first_name], last_name: params[:last_name])

    end

    if technologies && technologies.present?
      user.technologies.destroy_all
      for technology in  technologies
        user_skills = user.user_skills.build(technology_id: technology)
        user_skills.save
      end
    end 
    render json: {status: true}
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id]).to_json(include: [:role,:technologies,:teams])
  end

  def registration_params
    params.permit(:first_name,:last_name,:password,:confirm_password,:email,:role_id,:employee_id,:current_password)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  # def department_params
  #   params[:department].permit(:name)
  # end

end
