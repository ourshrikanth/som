class ResourceMailer < ActionMailer::Base
  default from: "zuber.surya@softwaysolutions.net"
=begin
#logic for sending Emails.
if current_user.id matches the resource_requests/user_id then he is the project manager and the email should go to admin.
   else it will go to project managers from current_user.id
**parameters need to be passed current_user object and resource_request object.
=end
  def ResourceRequestsAndReply(current_user, resource_request, comments)
    @current_user = current_user
    @resource_request = resource_request
    @comments = comments
    if ['submitted'].include?(@resource_request.status)
      # @admin = true
      @message = "Hi, <br/> #{@current_user.full_name()} has requested resource for #{@resource_request.project.name} <br/> #{@comments.comment} <br/>Regards <br/> #{@comments.user.full_name()} <br/> #{@comments.user.email}".html_safe
      admin_emails = User.where(status: 'active', role_id: 1).select(:email)
      admin_emails.each do |admin|
      mail to: admin.email, subject: "[SOM] Resource requested by #{@current_user.full_name()} for #{@resource_request.project.name}", cc: Settings.developer_mails
      end
    else
      @message = "Hi, <br/> your requested resource for #{@resource_request.project.name} has been #{@resource_request.status} <br/> #{@comments.comment} <br/>Regards <br/> #{@comments.user.full_name()} <br/> #{@comments.user.email}".html_safe
      mail to: @current_user.email, subject: "[SOM] Resource request has been #{@resource_request.status}", cc: Settings.developer_mails
    end
  end
end
