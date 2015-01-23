class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.column :status, "ENUM('active', 'inactive')"
      t.references :department, index: true
      t.timestamps
    end
  end
end
