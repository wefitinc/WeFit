class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :background
      t.text :text
      t.string :font
      t.string :color
      t.float :position_x
      t.float :position_y
      t.float :rotation

      t.string :latitude
      t.string :longitude

      t.belongs_to :user
      t.timestamps
    end
    add_index :posts, [:latitude, :longitude]
  end
end
