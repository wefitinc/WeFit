ActiveAdmin.register User do

  actions :all, :except => [:new]

  includes professional_services: [:service, :professional_service_lengths]

  filter :id
  filter :first_name
  filter :last_name
  filter :follower_count
  filter :following_count
  filter :reviews_count
  filter :rating
  filter :professional
  filter :professional_type, :as => :select, :collection => PROFESSIONAL_TYPES
  
  index do
    selectable_column
    column :id
    column :first_name
    column :last_name
    column :follower_count
    column :following_count
    column :reviews_count
    column :rating
    column :professional
    column :professional_type do |user|
      user.professional ? user.professional_type : "None"
    end
    column :license_number
    actions
  end

  show do
    attributes_table do
      row :id
      row :profile_image do |user|
        image_tag user.get_image_url, style: 'height:100px' rescue nil
      end
      row :first_name
      row :last_name
      row :follower_count
      row :following_count
      row :reviews_count
      row :rating
      row :professional
      row :professional_type do |user|
        user.professional ? user.professional_type : "None"
      end
      row :license_number
      row :facebook_link do |user|
        link_to("Facebook", user.facebook_link, target: :_blank)
      end
      row :instagram_link do |user|
        link_to("Instagram", user.instagram_link, target: :_blank)
      end
      row :twitter_link do |user|
        link_to("Twitter", user.twitter_link, target: :_blank)
      end
      row :activity_streak_counter
    end
    div :class => "panel" do
      h3 "Services"
      if user.professional && user.professional_services
        div :class => "panel_contents" do
          div :class => "attributes_table" do
            table do
              tr do
                th do
                  "Service"
                end
              end
              tbody do
                user.professional_services.includes(:professional_service_lengths).each do |pro_service|
                  tr do
                    td do
                      pro_service.service.name + ":" + pro_service.professional_service_lengths.map {|service_length| " #{service_length.length}#{pro_service.service.unit} for #{service_length.price}$"}.flatten.join(',')
                    end
                  end
                end
              end
            end
          end
        end
      else
        h3 "No Services Available"
      end
    end

  end
  
end
