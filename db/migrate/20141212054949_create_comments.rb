class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :comment
      t.references :planning_sheet, index: true
      t.references :user, index: true
      t.timestamps
    end
  end
end
