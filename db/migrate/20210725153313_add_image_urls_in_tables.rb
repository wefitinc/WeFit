class AddImageUrlsInTables < ActiveRecord::Migration[5.2]
  def change
  	add_column :activities, :image_url, :text
  	add_column :groups, :image_url, :text
  	add_column :topics, :image_url, :text
  	add_column :users, :image_url, :text
  end
end
