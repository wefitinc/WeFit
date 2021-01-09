class RemoveNullContraintsFromUnusedColumnsInPosts < ActiveRecord::Migration[5.2]
  def change
  	change_column :posts, :font_size, :float, :null => true
  end
end
