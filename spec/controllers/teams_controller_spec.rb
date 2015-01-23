require 'rails_helper'

RSpec.describe TeamsController, :type => :controller do
  # before(:each) do
  #   # ControllerMacros::login_user
  #     @current_user = FactoryGirl.create(:user)
  #     sign_in :user, @current_user
  # end
DatabaseCleaner.strategy = :transaction

  let(:valid_attributes) {
      {
        name: "PHP",
        status: "active",
        department_id: 1
      }
  }
  let(:status_changed) {
      {
        status: "inactive",
      }
  }
  describe "GET index" do
    it "assigns all teams as @teams" do
      team = Team.create! valid_attributes
      get :index, :format => :json
      expect(assigns(:teams)).to eq([team])
    end
  end

  describe "GET show" do
    it "assigns the requested team as @team" do
      team = Team.create! valid_attributes
      get :show, {:id => team.to_param}
      expect(assigns(:team)).to eq(team)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Team" do
        expect {
          post :create, {:team => valid_attributes}
        }.to change(Team, :count).by(1)
      end

      it "assigns a newly created team as @team" do
        post :create, {:team => valid_attributes}
        expect(assigns(:team)).to be_a(Team)
        expect(assigns(:team)).to be_persisted
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
          {
            status: "active",
            department_id: 2
          }
      }

      it "updates the requested team" do
        team = Team.create! valid_attributes
        put :update, {:id => team.to_param, :team => new_attributes}
        team.reload
      end

      it "assigns the requested team as @team" do
        team = Team.create! valid_attributes
        put :update, {:id => team.to_param, :team => valid_attributes}
        expect(assigns(:team)).to eq(team)
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested team" do
      team = Team.create! valid_attributes
      put :update, {:id => team.to_param, :team => status_changed}
      team.status = "inactive"
      team.status.should == "inactive"
    end
  end

end
