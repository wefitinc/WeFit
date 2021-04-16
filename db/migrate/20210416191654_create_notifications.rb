class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
    	t.references :user, foreign_key: true
      t.references :actor, foreign_key: {to_table: :users}, null: true
      t.references :creator, foreign_key: {to_table: :users}, null: true
      t.integer :notifiable_id
      t.string :notifiable_type
      t.integer :action, null: false
      t.boolean :is_seen, default: false, null: false
      t.boolean :is_deleted, default: false, null: false
      t.timestamps
    end
  end
end
