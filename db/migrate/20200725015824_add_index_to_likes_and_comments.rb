class AddIndexToLikesAndComments < ActiveRecord::Migration[5.2]
  def change
  	add_index :likes,    :owner_type
  	add_index :comments, :owner_type
  end
end
