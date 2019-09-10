class CreateProfessionals < ActiveRecord::Migration[5.2]
  def change
    create_table :professionals do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest
      t.string :type
      t.string :rate
      t.string :customer_id

      t.timestamps
    end
    add_index :professionals, :email, unique: true
  end
end
