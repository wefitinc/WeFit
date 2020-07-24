class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.references :user, foreign_key: true
      t.string :title
      t.string :location
      t.text :description
      t.boolean :public, default: true
      t.integer :members_count, default: 0

      t.timestamps
    end
  end
end
