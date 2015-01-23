require 'rails_helper'

RSpec.describe Comment, :type => :model do
    context "Associations" do

        it 'comments belongs to planning sheet' do
          comt = Comment.new
          comt.should respond_to(:planning_sheet)
        end
        it 'comments has one user' do
          comt = Comment.new
          comt.should respond_to(:user)
        end
        
    end # end of  Associations

    context "is not valid" do
      [:comment].each do |attr|
        it "without #{attr}" do
          subject.should_not be_valid
          subject.errors[attr].should_not be_empty
        end
        it "should be a proper and valid number" do
          comt = FactoryGirl.create(:comment)
          comt.valid? 
        end
      end
    end
end
