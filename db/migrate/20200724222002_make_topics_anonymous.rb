class MakeTopicsAnonymous < ActiveRecord::Migration[5.2]
  def change
  	add_column :topics, :anonymous, :boolean, default: false
  end
end
