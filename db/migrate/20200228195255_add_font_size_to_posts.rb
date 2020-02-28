class AddFontSizeToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :font_size, :float
  end
end
