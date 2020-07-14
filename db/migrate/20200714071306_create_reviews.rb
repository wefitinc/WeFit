class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.references :user, foreign_key: true
      t.references :professional, foreign_key: {to_table: :users}
      t.integer :stars
      t.text :text

      t.timestamps
    end
  end
end
