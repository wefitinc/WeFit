class MakeLikesPolymorphic < ActiveRecord::Migration[5.2]
  def change
    rename_column :likes, :post_id, :owner_id
    add_column    :likes, :owner_type, :string
  end
end
