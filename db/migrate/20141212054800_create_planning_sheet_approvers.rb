class CreatePlanningSheetApprovers < ActiveRecord::Migration
  def change
    create_table :planning_sheet_approvers do |t|
      t.references :user, index: true
      t.references :team, index: true
      t.timestamps
    end
  end
end
