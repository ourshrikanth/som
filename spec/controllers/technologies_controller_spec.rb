require 'rails_helper'


RSpec.describe TechnologiesController, :type => :controller do

  let(:valid_attributes) {
    {"name" => "php"}
  }

  describe "GET index" do
    it "assigns all technologies as @technologies" do
      technology = Technology.create! valid_attributes
      get :index
      expect(assigns(:technologies)).to eq([technology])
    end
  end

  describe "GET show" do
    it "assigns the requested technology as @technology" do
      technology = Technology.create! valid_attributes
      get :show, {:id => technology.to_param, format: :json}
      expect(assigns(:technology)).to eq(technology)
    end
  end

  describe "GET new" do
    it "assigns a new technology as @technology" do
      get :new, format: :json
      expect(assigns(:technology)).to be_a_new(Technology)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Technology" do
        expect {
          post :create, {:technology => valid_attributes}
        }.to change(Technology, :count).by(1)
      end

      it "assigns a newly created technology as @technology" do
        post :create, {:technology => valid_attributes}
        expect(assigns(:technology)).to be_a(Technology)
        expect(assigns(:technology)).to be_persisted
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        {:name => "ror"}
      }

      it "updates the requested technology" do
        technology = Technology.create! valid_attributes
        put :update, {:id => technology.to_param, :technology => new_attributes, format: :json}
        # technology.reload
        # technology.name = "ror"
        # expect(assigns(technology.name)).to eq("ror")
        response.should be_success
      end

      it "assigns the requested technology as @technology" do
        technology = Technology.create! valid_attributes
        put :update, {:id => technology.to_param, :technology => valid_attributes}
        expect(assigns(:technology)).to eq(technology)
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested technology" do
      technology = Technology.create! valid_attributes
     
        delete :destroy, {:id => technology.to_param, format: :json}
        technology.status = "inactive"
    
        expect(technology.status).to eq("inactive")
    end
  end

end
