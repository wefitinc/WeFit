class AddImageUrlInPosts < ActiveRecord::Migration[5.2]
  def change
  	add_column :posts, :media_url, :string, null: false
  end
end
