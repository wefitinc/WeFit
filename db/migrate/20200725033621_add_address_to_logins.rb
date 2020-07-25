class AddAddressToLogins < ActiveRecord::Migration[5.2]
  def change
    add_column :logins, :address, :string
  end
end
