class CreateHolidays < ActiveRecord::Migration
  def change
    create_table :holidays do |t|
      t.string :occassion
      t.date :holiday_date
      t.timestamps
    end
  end
end
