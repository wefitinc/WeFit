class AddLicenseNumberToUsers < ActiveRecord::Migration[5.2]
  def change
  	add_column :users, :license_number, :string
  end
end
