require 'rails_helper'

RSpec.describe PlannedTask, :type => :model do
    context "Associations" do

        it 'Planned task belongs to planning sheet' do
          pt = PlannedTask.new
          pt.should respond_to(:planning_sheet)
        end
        
    end # end of  Associations

    context "is not valid" do
      [:title, :work_hours, :billable_hours].each do |attr|
        it "without #{attr}" do
          subject.should_not be_valid
          subject.errors[attr].should_not be_empty
        end
        it "should be a proper and valid number" do
          pt = FactoryGirl.create(:planned_task)
          pt.valid? 
        end
      end
    end
end
