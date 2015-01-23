require 'rails_helper'


RSpec.describe PlannedTasksController, :type => :controller do

   before(:each) do
      @planning_sheet = FactoryGirl.create(:planning_sheet)
  end

  let(:valid_attributes) {
    {:title => "task 1",:work_hours => 5,:billable_hours => 4,:planning_sheet_id => @planning_sheet.id}
  }
  let(:new_attributes) {
    {:title => "task updated",:work_hours => 15}
  }
  # describe "GET index" do
  #   it "assigns all planned_tasks as @planned_tasks" do
  #     planned_task = PlannedTask.create! valid_attributes
  #     get :index, {}
  #     expect(assigns(:planned_tasks)).to eq([planned_task])
  #   end
  # end

  describe "GET show" do

    it "assigns the requested planned_task as @planned_task" do
      planned_task = PlannedTask.create! valid_attributes
      get :show, {:id => planned_task.to_param, format: :json}
      expect(assigns(:planned_task)).to eq(planned_task)
    end
  end

  # describe "GET new" do
  #   it "assigns a new planned_task as @planned_task" do
  #     get :new, {format: :json}
  #     expect(assigns(:planned_task)).to_json.to be_a_new(PlannedTask)
  #   end
  # end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new PlannedTask" do
        expect {
          post :create, {:data => valid_attributes, format: :json}
        }.to change(PlannedTask, :count).by(1)
      end

      it "assigns a newly created planned_task as @planned_task" do
        post :create, {:data => valid_attributes, format: :json}
        expect(assigns(:planned_task)).to be_a(PlannedTask)
        expect(assigns(:planned_task)).to be_persisted
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested planned_task" do
        planned_task = PlannedTask.create! valid_attributes
        put :update, {:id => planned_task.to_param, :data => new_attributes, format: :json}
        planned_task.reload
        response.should be_success
      end

      it "assigns the requested planned_task as @planned_task" do
        planned_task = PlannedTask.create! valid_attributes
        put :update, {:id => planned_task.to_param, :data => valid_attributes, format: :json}
        expect(assigns(:planned_task)).to eq(planned_task)
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested planned_task" do
      planned_task = PlannedTask.create! valid_attributes
      expect {
        delete :destroy, {:id => planned_task.to_param, format: :json}
      }.to change(PlannedTask, :count).by(-1)
    end
  end

end
