require "rails_helper"

RSpec.describe PlannedTasksController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/planned_tasks").to route_to("planned_tasks#index")
    end

    it "routes to #new" do
      expect(:get => "/planned_tasks/new").to route_to("planned_tasks#new")
    end

    it "routes to #show" do
      expect(:get => "/planned_tasks/1").to route_to("planned_tasks#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/planned_tasks/1/edit").to route_to("planned_tasks#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/planned_tasks").to route_to("planned_tasks#create")
    end

    it "routes to #update" do
      expect(:put => "/planned_tasks/1").to route_to("planned_tasks#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/planned_tasks/1").to route_to("planned_tasks#destroy", :id => "1")
    end
    # custom routes TDD
     it "routes to #getAllTasksOfSheet" do
      expect(:get => "/planned_tasks/getAllTasksOfSheet").to route_to("planned_tasks#getAllTasksOfSheet")
    end
  end
end
