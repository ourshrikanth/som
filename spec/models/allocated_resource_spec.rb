require 'rails_helper'

# RSpec.describe AllocatedResource, :type => :model do
#   pending "add some examples to (or delete) #{__FILE__}"

describe AllocatedResource do
  let(:resource) { FactoryGirl.create :allocated_resource }

  it 'can be created' do
    lambda {
      FactoryGirl.create(:allocated_resource)
      # AllocatedResource.create(:from_date=>'10-10-2014',:project_id => 1, :user_id => 1)
    }.should change(AllocatedResource, :count).by(1)
  end

	context 'Associations' do
		it 'belongs to user' do
		  subject.should respond_to(:user)	
		end

		it 'belongs to project' do
		  subject.should respond_to(:project)	
		end
  end
     #end of associations

  [:from_date, :to_date,:project_id,:user_id].each do |attr|
    it "without #{attr}" do
      subject.should_not be_valid
      subject.errors[attr].should_not be_empty
    end
  end

end #end of descibe 
