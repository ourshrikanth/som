require "rails_helper"

RSpec.describe PlanningSheet, :type => :mailer do
  before(:each) do
    @reciever = FactoryGirl.create(:user)
    @url = "sasjdhakh/sdfgdlkgjkdjf/dgkdh"
    @sender = User.create(:first_name => "zube", :last_name => "surya", :email => "zuber.surya@softwaysolutions.net", :password => "12345678", :password_confirmation => "12345678", :employee_id => "ewuy3243", :role_id => 1)
    @plan_sheet = FactoryGirl.create(:planning_sheet)
    @comment = Comment.create(:comment => "demo text")
    @plan_sheet_arr = [PlanningSheet.create( :status => "draft", :week_no => "12", :year => "2015",
          :from_date => "11-2-2015", :to_date => "16-2-2015", :total_hours => "40", :planned_hours => "23",
          :billable_hours => "20", :user_id => "2")]
    User.create(:first_name => "zube", :last_name => "surya", :email => "zuber.test.surya@softwaysolutions.net", :password => "12345678", :password_confirmation => "12345678", :employee_id => "ewuy32f43", :role_id => 2, status: 1)
    User.create(:first_name => "zube", :last_name => "surya", :email => "zuber.test2.surya@softwaysolutions.net", :password => "12345678", :password_confirmation => "12345678", :employee_id => "ewuy32f4g3", :role_id => 2, status: 1)
    @users = User.where(status: 1)
  end

  describe "planning_sheet_submit_notification" do
    let(:mail_w) { PlanningSheetMailer.planning_sheet_submit_notification( @sender, @reciever, @plan_sheet, @comment, @url) }
    it 'renders the reciever email' do
      expect(mail_w.to).to eql([@reciever.email])
    end
    it 'renders the sender email' do
      expect(mail_w.from).to eql([@sender.email])
    end

    it 'subject should not be empty' do
      expect(mail_w.subject).should_not be_nil
    end
  end

  describe "planning_sheet_approved_or_rejected_notification" do
    let(:mail_d) { PlanningSheetMailer.planning_sheet_approved_or_rejected_notification(  @reciever, @sender, @plan_sheet, @comment, @url) }
    it 'renders the reciever email' do
      expect(mail_d.to).to eql([@reciever.email])
    end
    it 'renders the sender email' do
      expect(mail_d.from).to eql([@sender.email])
    end
    it 'subject should not be empty' do
      expect(mail_d.subject).should_not be_nil
    end
  end
  describe "planning_sheet_fill_up_notification" do
    let(:mail_f) { PlanningSheetMailer.planning_sheet_fill_up_notification(@reciever, @url, @plan_sheet_arr) }
    it 'renders the reciever email' do
      expect(mail_f.to).to eql([@reciever.email])
    end
    it 'subject should not be empty' do
      expect(mail_f.subject).should_not be_nil
    end
  end

  describe "planning_sheet_not_submitted_nor_approved_notification" do
    let(:mail_sa) { PlanningSheetMailer.planning_sheet_not_submitted_nor_approved_notification(@users, @reciever) }
    it 'renders the reciever email' do
      expect(mail_sa.to).to eql([@reciever.email])
    end
    it 'subject should not be empty' do
      expect(mail_sa.subject).should_not be_nil
    end
  end
  describe "planning_sheet_final_notification" do
    let(:mail_fin) { PlanningSheetMailer.planning_sheet_final_notification(@reciever, @users) }
    it 'renders the reciever email' do
      expect(mail_fin.to).to eql([@reciever.email])
    end
    it 'subject should not be empty' do
      expect(mail_fin.subject).should_not be_nil
    end
  end

end
