require "rails_helper"

RSpec.describe TeamUsersController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/team_users").to route_to("team_users#index")
    end

    it "routes to #new" do
      expect(:get => "/team_users/new").to route_to("team_users#new")
    end

    it "routes to #show" do
      expect(:get => "/team_users/1").to route_to("team_users#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/team_users/1/edit").to route_to("team_users#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/team_users").to route_to("team_users#create")
    end

    it "routes to #update" do
      expect(:put => "/team_users/1").to route_to("team_users#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/team_users/1").to route_to("team_users#destroy", :id => "1")
    end
    # for custom functions.
    it "routes to #users_planning_sheet" do
      expect(:post => "/team_users/users_planning_sheet").to route_to("team_users#users_planning_sheet")
    end
     it "routes to #all_users_planning_sheets" do
      expect(:post => "/team_users/all_users_planning_sheets").to route_to("team_users#all_users_planning_sheets")
    end
     it "routes to #user_planning_sheet_detail" do
      expect(:post => "/team_users/user_planning_sheet_detail").to route_to("team_users#user_planning_sheet_detail")
    end
     it "routes to #update_planning_sheet" do
      expect(:post => "/team_users/update_planning_sheet").to route_to("team_users#update_planning_sheet")
    end
     it "routes to #isUserReviewer" do
      expect(:get => "/team_users/isUserReviewer").to route_to("team_users#isUserReviewer")
    end
    it "routes to #isSheetBelongsToTeam" do
      expect(:get => "/team_users/isSheetBelongsToTeam").to route_to("team_users#isSheetBelongsToTeam")
    end

  end
end
