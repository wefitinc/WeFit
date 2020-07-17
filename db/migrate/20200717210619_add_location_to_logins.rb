class AddLocationToLogins < ActiveRecord::Migration[5.2]
  def change
    add_column :logins, :latitude, :decimal
    add_column :logins, :longitude, :decimal
  end
end
