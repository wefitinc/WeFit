class RemoveAddressFromLogins < ActiveRecord::Migration[5.2]
  def change
  	remove_column :logins, :address
  end
end
