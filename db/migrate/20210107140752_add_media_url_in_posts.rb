class AddMediaUrlInPosts < ActiveRecord::Migration[5.2]
  def change
  	add_column :posts, :media_url, :string,  default: '', null: false
  end
end
