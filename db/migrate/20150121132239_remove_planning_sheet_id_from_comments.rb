class RemovePlanningSheetIdFromComments < ActiveRecord::Migration
  def change
    remove_column :comments, :planning_sheet_id, :integer
  end
end
