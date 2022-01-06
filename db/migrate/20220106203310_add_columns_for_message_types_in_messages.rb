class AddColumnsForMessageTypesInMessages < ActiveRecord::Migration[5.2]
  def change
  	add_column :messages, :user_location, :jsonb
  	add_column :messages, :media_urls, :text, array: true, default: []
  end
end
