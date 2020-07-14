class AddProfessionalRoleToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :professional,      :boolean, default: false
    add_column :users, :professional_type, :string,  default: "None"
    drop_table :professionals
  end
end
