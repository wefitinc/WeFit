class CreateProfessionalApplicationSubmissions < ActiveRecord::Migration[5.2]
  def change
    create_table :professional_application_submissions do |t|
    	t.references :user, foreign_key: true
      t.references :reviewer, foreign_key: {to_table: :users}, null: true
      t.integer :application_status, default: 0

      t.timestamps
    end
  end
end
