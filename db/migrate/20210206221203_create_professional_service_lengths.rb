class CreateProfessionalServiceLengths < ActiveRecord::Migration[5.2]
  def change
    create_table :professional_service_lengths do |t|
      t.decimal :length
      t.decimal :price
      t.references :professional_service, foreign_key: true

      t.timestamps
    end
  end
end
