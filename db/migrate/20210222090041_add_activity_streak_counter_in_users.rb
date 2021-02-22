class AddActivityStreakCounterInUsers < ActiveRecord::Migration[5.2]
  def change
  	add_column :users, :activity_streak_counter, :integer, default: 0
  end
end
