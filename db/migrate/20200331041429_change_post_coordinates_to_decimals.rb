class ChangePostCoordinatesToDecimals < ActiveRecord::Migration[5.2]
  def change
  	change_column :posts, :latitude, :decimal
  	change_column :posts, :longitude, :decimal
  end
end
