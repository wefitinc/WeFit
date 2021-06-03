class AddColumnsToMessages < ActiveRecord::Migration[5.2]
  def change
  	add_column :messages, :messageable_type, :string, null: false, default: 'Text'
  	add_column :messages, :messageable_id, :integer
  end
end
