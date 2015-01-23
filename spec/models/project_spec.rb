require 'rails_helper'


# RSpec.describe Project, :type => :model do
#   pending "add some examples to (or delete) #{__FILE__}"
# end

describe Project do
# subject { Factory.build(:project) }
let(:resource) { FactoryGirl.create :project }

it 'can be created' do
    lambda {
      Project.create(:name => "Thorovet", :user_id => 1)
    }.should change(Project, :count).by(1)
  end


	 describe "Associations" do
  #   it 'checks for the Associations' do
  # 	 [:allocated_resources,:user].each do |name|
  #  		subject.should respond_to(:user)
  #   end
  # end

	   it 'has many allocated resources' do
	   	  subject.should respond_to(:allocated_resources)
	   end
     it 'has many resource requests' do
        subject.should respond_to(:resource_requests)
   end
   it 'has many requested resources through resource_requests' do
        subject.should respond_to(:requested_resources)
   end
	   it 'created by user' do
	   	 subject.should respond_to(:user)
	   end

	end # end of  Associations

	  context "validation" do


      [:user_id,:name].each do |attr|
        it "without #{attr}" do
          subject.should_not be_valid
          subject.errors[attr].should_not be_empty
        end
      end

       it "should not be non-numerical" do
       subject.user_id = "asdf"
       subject.should_not be_valid
       end
     
  it "is invalid with a duplicate project name" do
      Project.create(
        user_id: 1,
        name: 'Thorovet'
      )
      project = Project.new(
        user_id: 1,
        name: 'Thorovet'
      )
     project.valid?
     expect(project.errors[:name]).to include("has already been taken")
  end

end #end of validation


         
	
  
end # end of describe

