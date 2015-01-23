require 'rails_helper'

RSpec.describe PlanningSheetsController, :type => :controller do

   before(:each) do
      @current_user = FactoryGirl.create(:user)
      sign_in :user, @current_user
  end
  it "should have a current_user" do
    # note the fact that I removed the "validate_session" parameter if this was a scaffold-generated controller
    subject.current_user.should_not be_nil
  end
  let(:valid_attributes) {
    {
      "status" => "draft",
      "week_no" => "12",
      "year" => "2015",
      "from_date" => "11-2-2015",
      "to_date" => "16-2-2015",
      "total_hours" => "40",
      "planned_hours" => "23",
      "billable_hours" => "20",
      "user_id" => "2"
    }
  }

  describe "GET index" do
    it "assigns all planning_sheets as @planning_sheets" do
      planning_sheet = PlanningSheet.create! valid_attributes
      # puts planning_sheet.inspect
      get :index, {order_by: {"planning_sheets.id"=> "desc"}, filters: "{}", page: 1, limit: 10, format: :json}
      # expect(assigns(:planning_sheets)).to eq([planning_sheet])
      response.should be_success
    end
  end

  describe "GET show" do
    it "assigns the requested planning_sheet as @planning_sheet" do
      planning_sheet = PlanningSheet.create! valid_attributes
      get :show, {:id => planning_sheet.id, format: :json}
      response.should be_success
    end
  end

  describe "GET new" do
    it "assigns a new planning_sheet as @planning_sheet" do
      get :new, {format: :json}
      expect(assigns(:planning_sheet)).to be_a_new(PlanningSheet)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new PlanningSheet" do
        expect {
          post :create, {:planning_sheet => valid_attributes, format: :json}
        }.to change(PlanningSheet, :count).by(1)
      end

      it "assigns a newly created planning_sheet as @planning_sheet" do
        post :create, {:planning_sheet => valid_attributes, format: :json}
        expect(assigns(:planning_sheet)).to be_a(PlanningSheet)
        expect(assigns(:planning_sheet)).to be_persisted
      end
    end
  end
end
