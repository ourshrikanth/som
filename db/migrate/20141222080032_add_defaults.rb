class AddDefaults < ActiveRecord::Migration
  def change
    change_column :departments,:status,"ENUM('active','inactive')", default: "active"
    change_column :projects,:status,"ENUM('active','inactive')", default: "active"
    change_column :roles,:status,"ENUM('active','inactive')", default: "active"
    change_column :teams,:status,"ENUM('active','inactive')", default: "active"
    change_column :technologies,:status,"ENUM('active','inactive')", default: "active"
  end
end
