class RemoveForeignKeyFromLikesAndComments < ActiveRecord::Migration[5.2]
  def change
  	if foreign_key_exists?(:likes, :posts)
      remove_foreign_key :likes, :posts
    end
    if foreign_key_exists?(:comments, :posts)
      remove_foreign_key :comments, :posts
    end
  end
end
