class CreateAllocatedResources < ActiveRecord::Migration
  def change
    create_table :allocated_resources do |t|
		t.date :from_date
		t.date :to_date
		t.references :project
		t.references :user
      t.timestamps
    end
  end
end
