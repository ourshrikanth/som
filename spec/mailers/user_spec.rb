require "rails_helper"

RSpec.describe User, :type => :mailer do

  before(:each) do
    @reciever = FactoryGirl.create(:user)
    @url = "sasjdhakh/sdfgdlkgjkdjf/dgkdh"
    @sender = User.create(:first_name => "zube", :last_name => "surya", :email => "zuber.surya@softwaysolutions.net", :password => "12345678", :password_confirmation => "12345678", :employee_id => "ewuy3243", :role_id => 1)
  end

  describe "welcome_user" do
    let(:mail_w) { UserMailer.welcome_user(@reciever, @sender, @reciever.password, @url) }
    it 'renders the reciever email' do
      expect(mail_w.to).to eql([@reciever.email])
    end
    it 'renders the sender email' do
      expect(mail_w.from).to eql([@sender.email])
    end

    it 'subject should not be empty' do
      expect(mail_w.subject).should_not be_nil
    end
    # it 'renders the welcome_user template' do
    #   expect(mail).to render_template("welcome_user") #should be_nil
    # end
  end

  describe "deactivation_confirmation" do
    let(:mail_d) { UserMailer.deactivation_confirmation(@reciever, @sender) }
    it 'renders the reciever email' do
      expect(mail_d.to).to eql([@reciever.email])
    end
    it 'renders the sender email' do
      expect(mail_d.from).to eql([@sender.email])
    end
    it 'subject should not be empty' do
      expect(mail_d.subject).should_not be_nil
      # puts mail_d.template_name
    end
    # it 'renders the deactivation_confirmation template' do
    #   expect(mail).to render_template("deactivation_confirmation")
    # end
  end

end
