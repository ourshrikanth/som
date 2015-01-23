class RolesController < ApplicationController
  def index
  	    @roles = Role.all
  	    respond_to do |format|
  	   	   format.json { render json: {roles:@roles,count: Role.all.count} }
        end
  end
end
	