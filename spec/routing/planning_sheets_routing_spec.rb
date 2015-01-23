require "rails_helper"

RSpec.describe PlanningSheetsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/planning_sheets").to route_to("planning_sheets#index")
    end

    it "routes to #new" do
      expect(:get => "/planning_sheets/new").to route_to("planning_sheets#new")
    end

    it "routes to #show" do
      expect(:get => "/planning_sheets/1").to route_to("planning_sheets#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/planning_sheets/1/edit").to route_to("planning_sheets#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/planning_sheets").to route_to("planning_sheets#create")
    end

    it "routes to #update" do
      expect(:put => "/planning_sheets/1").to route_to("planning_sheets#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/planning_sheets/1").to route_to("planning_sheets#destroy", :id => "1")
    end

  end
end
