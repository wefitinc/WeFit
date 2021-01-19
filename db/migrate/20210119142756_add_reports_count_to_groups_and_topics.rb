class AddReportsCountToGroupsAndTopics < ActiveRecord::Migration[5.2]
  def change
  	add_column :groups, :reports_count, :integer, default: 0
  	add_column :topics, :reports_count, :integer, default: 0
  end
end
