class AddColumnsInTopics < ActiveRecord::Migration[5.2]
  def change
  	add_column :topics, :mood, :string
  	add_column :topics, :link_urls, :text, array: true, default: []
  	add_column :topics, :media_urls, :text, array: true, default: []
  end
end
