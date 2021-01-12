class AddAbsenteesCountInActivities < ActiveRecord::Migration[5.2]
  def change
  	add_column :activities, :absentees_count, :integer, default: 0
  end
end
