class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  
  # GET /teams
  # GET /teams.json
  def index
    @teams = Team.active.all
    respond_to do |format|
      format.json { render json: @teams}
    end
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
    render json: @team
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams
  # POST /teams.json
  def create
    @team = Team.new(team_params)

    respond_to do |format|
      if @team.save
        format.html { redirect_to @team, notice: 'Team was successfully created.' }
        format.json { render json: @team }
      else
        format.html { render :new }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
   def update
    all_teams = Team.where("name=?",params[:name]).count
    if all_teams==0
      @team.update(name: params[:name])
      render json: {status: true, msg: ""}
    else
      render json: {status: false, msg: "Team name already present"}
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team.update(status: :inactive)
    render json: @team
  end

  def get_team_users
    render json: User.find(params[:user_id]).team_users.where("team_users.team_id=?",params[:team_id]).first.to_json(include: [:user])
    #render json: Team.joins(:users,:team_users).where("teams.id=? and users.id=?",params[:team_id],params[:user_id]).to_json(include: [:users,:team_users])
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_team
    @team = Team.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def team_params
    params[:team].permit(:name,:department_id)
  end
end
