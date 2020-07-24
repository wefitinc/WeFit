class CreateInvites < ActiveRecord::Migration[5.2]
  def change
    create_table :invites do |t|
      t.references :group, foreign_key: true
      t.references :user, foreign_key: true
      t.references :invited_by, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
