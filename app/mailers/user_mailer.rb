class UserMailer < ActionMailer::Base
  # default from: "no-reply@som.com"
  default from: "zuber.surya@softwaysolutions.net"



  def welcome_user(user, sender, urlpath, password)
    @recipient = user
    @password = password
    @message = "Hi #{@recipient.full_name}, You have been added to SOM. Please use your login credentials to plan your time"
    @sender = sender
    @url  = "#{urlpath}/#/login"
    mail to: @recipient.email, subject: " [SOM] Welcome to som", cc: Settings.developer_mails
  end

  def deactivation_confirmation(user, sender)
    @recipient = user
    @message = "Hi #{@recipient.full_name}, Your account has been deactivated"
    @sender = sender
    mail to: user.email, subject: "[SOM] User Deactivation", cc: Settings.developer_mails
  end

end
