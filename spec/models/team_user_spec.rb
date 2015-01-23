require 'rails_helper'

# RSpec.describe UserSkill, :type => :model do
#   pending "add some examples to (or delete) #{__FILE__}"
# end

describe TeamUser do

	it 'can be created' do
		lambda {
			FactoryGirl.create(:team_user)
		}.should change(TeamUser,:count).by(1)
	end

		context 'Associations' do
		it 'belongs to user' do
		  subject.should respond_to(:user)	
		end
		it 'belongs to team' do
		  subject.should respond_to(:team)	
		end
    end
     #end of associations

context 'validations' do
      [:team_id,:user_id].each do |attr|
        it "without #{attr}" do
          subject.should_not be_valid
          subject.errors[attr].should_not be_empty
        end
      end

  end

end