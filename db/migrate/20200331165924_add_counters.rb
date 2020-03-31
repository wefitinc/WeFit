class AddCounters < ActiveRecord::Migration[5.2]
  def change
  	add_column :posts, :likes_count, :integer, default: 0
  	add_column :posts, :views_count, :integer, default: 0
  	add_column :posts, :comments_count, :integer, default: 0

  	add_column :users, :follower_count, :integer, default: 0
  	add_column :users, :following_count, :integer, default: 0
  end
end
