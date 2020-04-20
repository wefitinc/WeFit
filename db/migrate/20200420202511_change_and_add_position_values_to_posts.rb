class ChangeAndAddPositionValuesToPosts < ActiveRecord::Migration[5.2]
  def change
    rename_column :posts, :rotation,   :textview_rotation
    rename_column :posts, :position_x, :textview_position_x
    rename_column :posts, :position_y, :textview_position_y

    add_column :posts, :image_rotation, :float
    add_column :posts, :image_position_x, :float
    add_column :posts, :image_position_y, :float
    add_column :posts, :image_width, :float
    add_column :posts, :image_height, :float
  end
end
