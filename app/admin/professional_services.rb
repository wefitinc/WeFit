ActiveAdmin.register ProfessionalService do

  actions :all, :except => [:new]
  
  permit_params do
    permitted = :application_status if (params[:action] == 'update')
    permitted
  end

  includes :service
  includes :professional_service_lengths
  includes :user

  filter :id
  filter :service, :as => :select, :collection => Service.all.collect {|o| [o.name, o.id]}
  
  index do
    selectable_column
    column :id
    column :user
    column :service do |professional_service|
      professional_service.service.name
    end
    column :service_lengths do |professional_service|
      professional_service.professional_service_lengths.map {|service_length| "#{service_length.length} #{professional_service.service.unit} for #{service_length.price}$"}
    end

    actions
  end

  show do
    attributes_table do
      row :id
      row :user
      row :service do |professional_service|
        professional_service.service.name
      end
      row :service_lengths do |professional_service|
        professional_service.professional_service_lengths.map {|service_length| "#{service_length.length} #{professional_service.service.unit} for #{service_length.price}$"}
      end
      row :description
    end
  end
  
end
