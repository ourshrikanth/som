require 'rails_helper'

RSpec.describe ResourceRequest, :type => :model do
  # pending "add some examples to (or delete) #{__FILE__}"

    it 'can be created' do
    lambda {
      ResourceRequest.create(:comments => "comment sample", :user_id => 1, :status => 'requested', :project_id => 1)}.should change(ResourceRequest, :count).by(1)
  end

  context "Associations" do

        it 'Resource Request has one user ( project manager) ' do
          ps = ResourceRequest.new
          ps.should respond_to(:user)
        end
        it 'Resource Request belongs to project' do
          ps = ResourceRequest.new
          ps.should respond_to(:project)
        end
        it 'Resource Request has many requested resources for the project' do
          ps = ResourceRequest.new
          ps.should respond_to(:requested_resources)
        end
    end # end of  Associations

     context "is not valid" do
      [:user_id,:status,:project_id].each do |attr|
        it "without #{attr}" do
          subject.should_not be_valid
          subject.errors[attr].should_not be_empty
        end
      end
    end
end
