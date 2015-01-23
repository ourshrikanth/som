require 'rails_helper'

RSpec.describe RequestedResource, :type => :model do
  # pending "add some examples to (or delete) #{__FILE__}"

   it 'can be created' do
    lambda {
      RequestedResource.create(:start_date => "03-02-2014",:end_date => "03-02-2014", :hours => 20.0, :resource_request_id => 1, :user_id => 1)}.should change(RequestedResource, :count).by(1)
  end

  context "Associations" do

        it 'RequestedResource has many users requested for resource allocation' do
          ps = RequestedResource.new
          ps.should respond_to(:user)
        end
        it 'RequestedResource belongs to Resource Request Model' do
          ps = RequestedResource.new
          ps.should respond_to(:resource_requests)
        end
       
    end # end of  Associations

    
     context "is not valid" do
      [:start_date,:end_date,:hours,:resource_request_id,:user_id].each do |attr|
        it "without #{attr}" do
          subject.should_not be_valid
          subject.errors[attr].should_not be_empty
        end
        
      end
    end
end
