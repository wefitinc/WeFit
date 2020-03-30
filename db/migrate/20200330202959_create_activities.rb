class CreateActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :activities do |t|
      t.references :user, foreign_key: true
      t.string :name
      t.text :description
      t.datetime :event_time
      t.string :google_placeID
      t.string :location_name
      t.string :location_address
      t.integer :difficulty

      t.timestamps
    end
  end
end
