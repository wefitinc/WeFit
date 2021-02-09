class CreateServiceRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :service_requests do |t|
    	
    	t.references :user, foreign_key: true
      t.references :professional, foreign_key: {to_table: :users}
      t.references :professional_service_length, foreign_key: true, null: true

      t.string :details
      t.string :delivery_method
      t.string :phone
      t.string :email
      t.datetime :time
      t.decimal :price, null: false, default: 0

      t.integer :service_request_status, default: 0
      t.boolean :is_custom, default: true

      t.timestamps
    end
  end
end