class CreatePlannedTasks < ActiveRecord::Migration
  def change
    create_table :planned_tasks do |t|
      t.text :title
      t.decimal :work_hours, precision: 5, scale: 2
      t.decimal :billable_hours, precision: 5, scale: 2
      t.references :planning_sheet, index: true
      t.timestamps
    end
  end
end
