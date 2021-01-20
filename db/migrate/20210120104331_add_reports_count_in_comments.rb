class AddReportsCountInComments < ActiveRecord::Migration[5.2]
  def change
  	add_column :comments, :reports_count, :integer, default: 0
  end
end
