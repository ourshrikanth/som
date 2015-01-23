require 'rails_helper'

# RSpec.describe Technology, :type => :model do
#   pending "add some examples to (or delete) #{__FILE__}"
# end
describe Technology do

	it 'can be created' do
	    lambda {
	      	technology = FactoryGirl.create(:technology)
	    }.should change(Technology, :count).by(1)
    end

	context "Associations" do
		 it 'has many users' do
	          subject.should respond_to(:users)
	        end
	        it 'can have many technologies' do
	          subject.should respond_to(:user_skills)
	        end

	end

	[:name].each do |attr|
        it "without #{attr}" do
          subject.should_not be_valid
          subject.errors[attr].should_not be_empty
        end
      end

end #end of Technology describe

