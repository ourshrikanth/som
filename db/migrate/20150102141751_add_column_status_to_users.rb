class AddColumnStatusToUsers < ActiveRecord::Migration
  def change
  	add_column :users,:status,"ENUM('active','inactive')", default: "active"
  end
end
