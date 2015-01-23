require 'rails_helper'

# RSpec.describe Team, :type => :model do
#   pending "add some examples to (or delete) #{__FILE__}"
# end
describe Team do

	it 'can be created' do
	    lambda {
	      	team = FactoryGirl.create(:team)
	    }.should change(Team, :count).by(1)
    end

	context "associations" do
		 it 'has many users' do
	          subject.should respond_to(:users)
	        end
	         it 'has many users through' do
	          subject.should respond_to(:team_users)
	        end
	        it 'belongs to ' do
	          subject.should respond_to(:department)
	        end
     end

     context 'validations' do

     	 [:name,:department_id].each do |attr|
        it "without #{attr}" do
          subject.should_not be_valid
          subject.errors[attr].should_not be_empty
        end
      end

		it "is invalid with a duplicate team name" do
			Team.create(
				name: 'ror',
				department_id: 1
			)
			team = Team.new(
				name: 'ror',
				department_id:1
			)
			team.valid?
			expect(team.errors[:name]).to include("has already been taken")
		end

     end



end