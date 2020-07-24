class MakeCommentsPolymorphic < ActiveRecord::Migration[5.2]
  def change
  	rename_column :comments, :post_id, :owner_id
    add_column    :comments, :owner_type, :string
  end
end
