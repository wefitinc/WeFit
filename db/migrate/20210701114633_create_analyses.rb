class CreateAnalyses < ActiveRecord::Migration[5.2]
  def change
    create_table :analyses do |t|
    	t.integer :users_count
      t.integer :posts_count
      t.integer :activities_count
      t.integer :groups_count
      t.integer :groups_joined_count
      t.integer :day
      t.integer :week

      t.timestamps
    end
  end
end
