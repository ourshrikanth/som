class ChangeStatusColumnDefaultValuesOfResourceRequests < ActiveRecord::Migration
  def change
  	    change_column :resource_requests,:status,"ENUM('cancelled', 'approved', 'submitted', 'rejected')", default: "submitted"

  end
end
