class DropPlanningSheetApprover < ActiveRecord::Migration
  def change
  	drop_table :planning_sheet_approvers
  end
end
