class AddLocationInLogins < ActiveRecord::Migration[5.2]
  def change
  	add_column :logins, :location, :string
  end
end
