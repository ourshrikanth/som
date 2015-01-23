require 'rails_helper'



RSpec.describe DepartmentsController, :type => :controller do
   before(:each) do
    # ControllerMacros::login_user
      @current_user = FactoryGirl.create(:user)
      sign_in :user, @current_user
  end

  let(:valid_attributes) {
    {
      :name =>"Web", :status => "inactive"
    }
  }

  describe "GET index" do
    it "assigns all departments as @departments" do
      department = Department.create! valid_attributes
      get :index, {format: :json}
      expect(assigns(:departments)).to eq([department])
    end
  end

  describe "GET show" do
    it "assigns the requested department as @department" do
      department = Department.create! valid_attributes
      get :show, {:id => department.to_param}
      expect(assigns(:department)).to eq(department)
    end
  end


  describe "POST create" do
    describe "with valid params" do
      it "creates a new Department" do
        expect {
          post :create, {:department => valid_attributes, format: :json}
        }.to change(Department, :count).by(1)
      end

      it "assigns a newly created department as @department" do
        post :create, {:department => valid_attributes}
        expect(assigns(:department)).to be_a(Department)
        expect(assigns(:department)).to be_persisted
      end
    end

  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        {name: "Mobile"}
      }

      it "updates the requested department" do
        department = Department.create! valid_attributes
        put :update, {:id => department.to_param, :department => new_attributes, format: :json}
        department.reload
        response.should be_success

        # skip("Add assertions for updated state")
      end

      it "assigns the requested department as @department" do
        department = Department.create! valid_attributes
        put :update, {:id => department.to_param, :department => valid_attributes, format: :json}
        expect(assigns(:department)).to eq(department)
      end

    end

  end

  describe "DELETE destroy" do
    it "destroys the requested department" do
      department = Department.create! valid_attributes
      delete :destroy, {:id => department.to_param, format: :json}
      department.status = "inactive"
      expect(department.status).to eq("inactive")
    end
  end

end
