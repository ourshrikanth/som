require 'rails_helper'

RSpec.describe UsersController, :type => :controller do

   before(:each) do
      @current_user = FactoryGirl.create(:user)
      sign_in :user, @current_user
  end
  let(:status_changed) {
      {
        status: "inactive",
      }
  }
  let(:valid_attributes) {
            {
              first_name: "Jona2",
              last_name: "Smith2",
              email: "test2@example.com",
              password: "123456",
              password_confirmation: "123456",
              employee_id: "1234562",
              role_id: "1"
            }
  }
  let(:new_attributes) {
      {
        first_name: "johnathon",
      }
  }
  it "should have a current_user" do
    # note the fact that I removed the "validate_session" parameter if this was a scaffold-generated controller
    subject.current_user.should_not be_nil
  end

  describe "GET index" do
    it "responds successfully" do
      get :index, {order_by: {"users.id"=> "desc"}, filters: "{}", page: 1, limit: 10}
      response.should be_success
    end
  end

  describe "GET show" do
    it "assigns the requested user as @user" do
      user = User.create!(first_name: "qwewq", last_name: "dsffg", employee_id: "ss2001", email: "asdf@yopmail.com", password: "123456789", password_confirmation:  "123456789", role_id: "1")
      get :show, {:id => user.id}
      response.should be_success
    end
  end

  describe "POST save" do
    describe "with valid params" do
      it "saves a new User" do
          user = User.create!("first_name"=>"unanimous", "last_name"=>"rockstar", 
            "email"=>"abdsfd@yopmail.com", "role_id"=>"2", "employee_id"=>"dfg2255", 
            "password"=>"12345678", "confirm_password"=>"12345678")
          post :save, {"newTeams"=>nil, "technologies"=>[2]}
          response.should be_success
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {:first_name}
      it "updates the requested user" do
        user = User.create! valid_attributes
        put :update, {:id => user.to_param, :user => new_attributes, format: :json}
        user.reload
        response.should be_success
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested user" do
      #before running this action you need to run start redis as well as sidekiq because we are sending mails.
      user = User.create! valid_attributes
      put :update, {:id => user.to_param, :team => status_changed}
      user.status = "inactive"
      # user.status.should == "inactive"
      put :destroy, :id => user.to_param, :user => {:status => 'inactive'}
      user.reload.status.should == "inactive"
    end
  end

end



# notes
# to run a perticular example in this spec  file you can write
#[rspec spec/controllers/users_controller_spec.rb:68] where 68 is line number.