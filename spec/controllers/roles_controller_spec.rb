require 'rails_helper'


RSpec.describe RolesController, :type => :controller do


  describe "GET index" do
    it "assigns all roles as @roles" do
      role = Role.create!(name: "superAdmin")
      get :index, {format: :json}
      expect(assigns(:roles)).to eq([role])
    end
  end
end
