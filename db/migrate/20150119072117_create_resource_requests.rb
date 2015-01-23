class CreateResourceRequests < ActiveRecord::Migration
  def change
    create_table :resource_requests do |t|
      t.text :comments
      t.integer :user_id
      t.column :status, "ENUM('cancelled','approved','submitted','rejected')", default: "submitted"
      t.integer :project_id
      t.references :project, index: true
      t.references :user, index: true
      t.timestamps
    end
  end
end
