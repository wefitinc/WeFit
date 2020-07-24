class AddTopicsCountToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :topics_count, :integer, default: 0
  end
end
