class AddReviewsCountInUsers < ActiveRecord::Migration[5.2]
  def change
  	add_column :users, :reviews_count, :integer, default: 0
  end
end
