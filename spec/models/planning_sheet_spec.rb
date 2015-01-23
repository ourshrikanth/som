require 'rails_helper'

RSpec.describe PlanningSheet, :type => :model do

  it 'can be created' do
    lambda {
      PlanningSheet.create(:week_no => 1, :from_date => "03-02-2014", :to_date => '11-02-2014', :total_hours => 40, :planned_hours => 4, :year => 2014, :billable_hours => 2, :user_id => 1)}.should change(PlanningSheet, :count).by(1)
  end
    context "Associations" do

        it 'Planning sheet has one user' do
          ps = PlanningSheet.new
          ps.should respond_to(:user)
        end
        it 'planning sheet can have many comments' do
          ps = PlanningSheet.new
          ps.should respond_to(:comments)
        end
        it 'planning sheet can have many planned tasks' do
          ps = PlanningSheet.new
          ps.should respond_to(:planned_tasks)
        end
    end # end of  Associations

    context "is not valid" do
      [:week_no,:from_date,:to_date, :total_hours, :planned_hours, :year, :billable_hours,:user_id].each do |attr|
        it "without #{attr}" do
          subject.should_not be_valid
          subject.errors[attr].should_not be_empty
        end
        it "should be a proper and valid number" do
          ps = FactoryGirl.create(:planning_sheet)
          ps.valid?
        end
      end
    end

    context "planning_sheet_not_submitted_before_friday_evening" do

      it 'has the method' do
        PlanningSheet.should respond_to(:planning_sheet_not_submitted_before_friday_evening)
      end

    end
    context "planning_sheet_crossed_deadline" do

      it 'has the method' do
        PlanningSheet.should respond_to(:planning_sheet_crossed_deadline)
      end


    end
    context "planning_sheet_reminder" do

      it 'has the method' do
        PlanningSheet.should respond_to(:planning_sheet_reminder)
      end


    end
    # context "add_sheet" do

    #   it 'has the method' do
    #     PlanningSheet.should respond_to(:add_sheet)
    #   end
    #   it "should create a new planning sheet" do
    #       PlanningSheet.create!(week_no: 2, year: 2014, from_date: "11-1-2014", to_date: "18-2-2014", total_hours: 40, planned_hours: 12,billable_hours: 1, user_id: 1, status: 'draft')
    #       expect(PlanningSheet.count).to eq 1
    #     end

    # end

end
