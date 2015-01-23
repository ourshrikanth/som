class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # before_action :authenticate_user!
  include ApplicationHelper
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
 
  respond_to :json
  def som
  	render 'layouts/application'
  end


  private
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:role_id,:employee_id,:first_name,:last_name,:team_id]
  end
end
