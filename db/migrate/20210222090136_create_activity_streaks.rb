class CreateActivityStreaks < ActiveRecord::Migration[5.2]
  def change
    create_table :activity_streaks do |t|
      t.date :date
      t.references :user, foreign_key: true
      t.boolean :is_activity_done, default: false

      t.timestamps
    end
  end
end
