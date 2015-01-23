class CreatePlanningSheets < ActiveRecord::Migration
  def change
    create_table :planning_sheets do |t|
      t.column :status, "ENUM('draft','approved','submitted','rejected')"
      t.integer :week_no
      t.integer :year
      t.date :from_date
      t.date :to_date
      t.decimal :total_hours, precision: 5, scale: 2
      t.decimal :planned_hours, precision: 5, scale: 2
      t.decimal :billable_hours, precision: 5, scale: 2
      t.references :user, index: true
      t.timestamps
    end
  end
end
