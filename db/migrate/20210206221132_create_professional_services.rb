class CreateProfessionalServices < ActiveRecord::Migration[5.2]
  def change
    create_table :professional_services do |t|
      t.references :service, foreign_key: true
      t.references :user, foreign_key: true
      t.text :description

      t.timestamps
    end
  end
end
