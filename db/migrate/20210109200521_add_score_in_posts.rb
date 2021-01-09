class AddScoreInPosts < ActiveRecord::Migration[5.2]
  def change
  	add_column :posts, :score, :float, default: 0
  end
end
