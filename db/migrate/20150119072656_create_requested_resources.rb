class CreateRequestedResources < ActiveRecord::Migration
  def change
    create_table :requested_resources do |t|
      t.date :start_date
      t.date :end_date
      t.decimal :hours, precision: 5, scale: 2
      t.integer :resource_request_id
      t.integer :user_id
      t.references :resource_request, index: true
      t.references :user, index: true
      t.timestamps
    end
  end
end
