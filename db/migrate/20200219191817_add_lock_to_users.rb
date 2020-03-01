class AddLockToUsers < ActiveRecord::Migration[5.2]
  def change
  	add_column :users, :failed_attempts, :integer, default: 0
  	add_column :users, :unlock_digest, :string
  	add_column :users, :locked_at, :datetime
  end
end
