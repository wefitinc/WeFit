class CreateParticipants < ActiveRecord::Migration[5.2]
  def change
    create_table :participants do |t|
    	t.references :activity, foreign_key: true
      t.references :user, foreign_key: true
      t.boolean :is_attending, null: false, default: false
      
      t.timestamps
    end
  end
end
