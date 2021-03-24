ActiveAdmin.register ProfessionalApplicationSubmission do

  actions :all, :except => [:new]
  
  permit_params do
    permitted = :application_status, :reviewer_id if (params[:action] == 'update')
    permitted
  end

  includes user: :professional_services
  includes :reviewer

  filter :application_status, as: :select, collection: ProfessionalApplicationSubmission.application_statuses
  
  index do
    selectable_column
    column :id
    column :application_status
    column :user do |professional_application_submission|
      link_to(professional_application_submission.user.name, admin_user_path(professional_application_submission.user.id)) 
    end
    column :services do |professional_application_submission|
      professional_application_submission.user.professional_services.pluck(:id).map{|service_id| 
        link_to(service_id,admin_professional_service_path(service_id)) }
    end
    column :reviewer
    column :is_reviewed? do |professional_application_submission|
      professional_application_submission.reviewer_id.present?
    end
    actions
  end

  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs "ProfessionalApplicationSubmission" do
      input :id
      input :application_status
      input :reviewer_id, :as => :hidden
    end
    f.actions # adds the 'Submit' and 'Cancel' buttons
  end

  show do
    attributes_table do
      row :id
      row :application_status
      row :services do |professional_application_submission|
        professional_application_submission.user.professional_services.pluck(:id).map{|service_id| 
          link_to(service_id,admin_professional_service_path(service_id)) }
      end
      row :user
      row :reviewer
    end
  end

  controller do
    def update
      if params["professional_application_submission"]["reviewer_id"].present?
        flash[:error] = "This application is already reviewed. Can not review again."
        redirect_to admin_professional_application_submissions_path
      else
        params["professional_application_submission"]["reviewer_id"] = current_admin.id
        super
      end
    end
  end

end
