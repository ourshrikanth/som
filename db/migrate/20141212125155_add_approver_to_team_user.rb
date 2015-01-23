class AddApproverToTeamUser < ActiveRecord::Migration
  def change
    add_column :team_users, :approver, :boolean
  end
end
