require 'rails_helper'


RSpec.describe TeamUsersController, :type => :controller do
   before(:each) do
      @current_user = FactoryGirl.create(:user)
      sign_in :user, @current_user
  end

  let(:valid_attributes_comment) {
  { :comment=> "Hello Hi", :planning_sheet_id => 1, :user_id => 1}
  }
 let(:valid_attributes_team_user) {
  { :team_id=> 1, :user_id => 1}
  }

  let(:valid_attributes_planning_sheet) {
    {
      "status" => "draft",
      "week_no" => "12",
      "year" => "2015",
      "from_date" => "11-2-2015",
      "to_date" => "16-2-2015",
      "total_hours" => "40",
      "planned_hours" => "23",
      "billable_hours" => "20",
      "user_id" => @current_user.id
    }
  }
  describe "GET index" do
    it "returns a success response" do
          team_user = TeamUser.create! valid_attributes_team_user
          get :index, {:page => 10, format: :json}
          response.should be_success
    end
  end

  describe "POST all_users_planning_sheets" do
    it "returns a success response" do
          post :all_users_planning_sheets, {:order_by => {"planning_sheets.id" => "desc"}, format: :json}
          response.should be_success
    end
  end

  describe "POST users_planning_sheet" do
    it "returns a success response" do
          post :users_planning_sheet, {:order_by => {"planning_sheets.id" => "desc"}, :team_id => "1", format: :json}
          response.should be_success
    end
  end

  describe "GET isUserReviewer" do
    it "returns a success response" do
          get :isUserReviewer
          response.should be_success
    end
  end

  describe "GET isSheetBelongsToTeam" do
    it "returns a success response" do
          get :isSheetBelongsToTeam, {:sheet_id => 2, :user_id => 1}
          response.should be_success
    end
  end

  describe "POST user_planning_sheet_detail" do
      it "returns a success response" do
          post :user_planning_sheet_detail, {data: {:order_by => {"planning_sheets.id" => "desc"}}}
          response.should be_success
      end
  end

  describe "POST update_planning_sheet" do
      it "returns a success response" do
          ps = PlanningSheet.create! valid_attributes_planning_sheet
          post :update_planning_sheet, {:id => ps.id, format: :json}
          response.should be_success
      end
  end

end
