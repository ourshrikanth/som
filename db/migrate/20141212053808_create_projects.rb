class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.column :status, "ENUM('active','inactive')"
      t.timestamps
    end
  end
end
