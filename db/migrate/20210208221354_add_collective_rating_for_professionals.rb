class AddCollectiveRatingForProfessionals < ActiveRecord::Migration[5.2]
  def change
  	add_column :users, :rating, :decimal
  end
end
