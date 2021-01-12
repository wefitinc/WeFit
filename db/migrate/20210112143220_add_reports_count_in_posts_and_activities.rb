class AddReportsCountInPostsAndActivities < ActiveRecord::Migration[5.2]
  def change
  	add_column :posts, :reports_count, :integer, defaul: 0
  	add_column :activities, :reports_count, :integer, defaul: 0
  end
end
