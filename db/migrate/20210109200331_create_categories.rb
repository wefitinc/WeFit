class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string :name

      t.timestamps
    end

    init_categories
  end

  def init_categories
  	category_names = ["Health & Fitness", "Food & Recipes", "Workout", "Motivation", "Education", "Outdoors"]
  	category_names.each do |name|
  		Category.create(name: name)
  	end
	end

end


