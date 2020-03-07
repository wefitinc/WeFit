class AddDisplayValuesToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :textview_width, :float
    add_column :posts, :textview_height, :float
    add_column :posts, :header_color, :string
  end
end
