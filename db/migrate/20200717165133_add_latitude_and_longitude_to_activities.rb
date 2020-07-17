class AddLatitudeAndLongitudeToActivities < ActiveRecord::Migration[5.2]
  def change
  	add_column :activities, :latitude, :decimal
  	add_column :activities, :longitude, :decimal
  end
end
