require 'rails_helper'

# RSpec.describe Role, :type => :model do
#   pending "add some examples to (or delete) #{__FILE__}"
# end

describe Role do
	it 'can be created' do
		lambda {
			role = FactoryGirl.create(:role)
		}.should change(Role,:count).by(1)
	end

		it 'has many users' do
	   	  subject.should respond_to(:users)
	   end
  context 'validations' do

	    [:name].each do |attr|
        it "without #{attr}" do
          subject.should_not be_valid
          subject.errors[attr].should_not be_empty
        end
      end

      it "is invalid with a duplicate role name" do
      Role.create(
        name: 'employee'
      )
      role = Role.new(
        name: 'employee'
      )
     role.valid?
     expect(role.errors[:name]).to include("has already been taken")
  end


	end #end of describe validations

end

