class AddDefaultToFontSize < ActiveRecord::Migration[5.2]
  def change
    change_column_null :posts, :font_size, false, 16
  end
end
