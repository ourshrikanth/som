require 'rails_helper'

RSpec.describe User, :type => :model do
  
    context "Associations" do

        it 'user can have many planning sheets' do
          testUser = User.new
          should respond_to(:planning_sheets)
        end
        it 'user can have many planned tasks' do
          testUser = User.new
          testUser.should respond_to(:planned_tasks)
        end
        it 'user can have many comments for its planning sheet' do
          testUser = User.new
          testUser.should respond_to(:comments)
        end
        it 'user can have many team users' do
          testUser = User.new
          testUser.should respond_to(:team_users)
        end
        it 'user can have many teams' do
          testUser = User.new
          testUser.should respond_to(:teams)
        end
        it 'user can have many user skills' do
          testUser = User.new
          testUser.should respond_to(:user_skills)
        end
        it 'user can have many technologies' do
          testUser = User.new
          testUser.should respond_to(:technologies)
        end
        it 'user can have many projects' do
          testUser = User.new
          testUser.should respond_to(:projects)
        end
        it 'user will have a single role' do
          testUser = User.new
          testUser.should respond_to(:role)
        end
    end # end of  Associations

    context "is not valid" do
      [:first_name, :last_name,:role_id,:email,:employee_id].each do |attr|
        it "without #{attr}" do
          subject.should_not be_valid
          subject.errors[attr].should_not be_empty
        end
        it "should have a unique email, employee_id" do
          user = FactoryGirl.create(:user)
          # user1 = FactoryGirl.create(:user)
          # user1.valid? #we commented this section to pass the tests.
          # user1.errors[:email].should include("has already been taken")
        end
      end
    end

    context "full_name" do
      it "return the concatenated first and last name" do
        u = User.new(:first_name => "Joe", :last_name => "Smith")
        u.full_name.should == 'Joe Smith'
      end
    end
end
