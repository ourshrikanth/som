class PlannedTask < ActiveRecord::Base
belongs_to :planning_sheet

validates :title, :work_hours, :billable_hours, :planning_sheet_id, presence: true
validates :work_hours, :billable_hours,  numericality: { greater_than_or_equal_to: 0  }
validates_associated :planning_sheet
end
