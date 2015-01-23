class CreateTechnologies < ActiveRecord::Migration
  def change
    create_table :technologies do |t|
      t.string :name
      t.column :status, "ENUM('active','inactive')"

      t.timestamps
    end
  end
end
