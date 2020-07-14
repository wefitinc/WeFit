class ChangeProfessionalToReviewer < ActiveRecord::Migration[5.2]
  def change
  	rename_column :reviews, :user_id, :reviewer_id
  	rename_column :reviews, :professional_id, :user_id
  end
end
