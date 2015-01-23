require 'rails_helper'

RSpec.describe Department, :type => :model do
    context "Associations" do

        it 'has many teams under one department' do
          dept = Department.new
          dept.should respond_to(:teams)
        end
        
    end # end of  Associations

    context "is not valid" do
      [:name].each do |attr|
        it "without #{attr}" do
          subject.should_not be_valid
          subject.errors[attr].should_not be_empty
        end
      end
    end
end
