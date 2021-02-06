class CreateServices < ActiveRecord::Migration[5.2]
  def change
    create_table :services do |t|
      t.string :name
      t.string :unit
      t.string :professional_type

      t.timestamps
    end

		init_services    
  end

  def init_services
  	services = {
  		"Dietitian" => [
  			{name: "Health Coaching", unit: "Minutes"}, 
  			{name: "Meal Plan", unit: "Weeks"}
  		],
  		"Personal Trainer" => [
  			{name: "Personal Training", unit: "Minutes"}, 
  			{name: "Health Coaching", unit: "Minutes"}, 
  			{name: "Meal Plan", unit: "Weeks"},
  			{name: "Workout Plan", unit: "Weeks"}
  		],
  		"Psychiatrist" => [
  			{name: "Initial Consultation", unit: "Minutes"}, 
  			{name: "Counseling", unit: "Minutes"}, 
  			{name: "Treatment Plan", unit: "Weeks"} 
  		],
  		"Psychologist" => [
  			{name: "Initial Consultation", unit: "Minutes"}, 
  			{name: "Counseling", unit: "Minutes"}, 
  			{name: "Treatment Plan", unit: "Weeks"} 
  		]
  	}
  	

  	["Personal Trainer", "Dietitian", "Psychiatrist", "Psychologist"].each do |professional_type|
  		services[professional_type].each do |service|
  			Service.create(name: service[:name], unit: service[:unit], professional_type: professional_type)
  		end
  	end

	end

end
