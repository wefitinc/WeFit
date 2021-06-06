module ApplicationHelper
  # Set the title of a page
  def title(text)
    content_for :title, text
  end

  def meta_tag(tag, text)
    content_for :"meta_#{tag}", text
  end
  def yield_meta_tag(tag, default_text='')
    content_for?(:"meta_#{tag}") ? content_for(:"meta_#{tag}") : default_text
  end

  # Get the current user id OR nil if no user
  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    else
      @current_user = nil
    end
  end
  # Check if a user is logged in
  def current_user?
    current_user != nil
  end

  # Page classes for JS markers
  def login_status
    current_user? ? 'logged_in' : 'logged_out'
  end
  def login_error
    flash[:login_notice] ? 'login_error' : ''
  end

  # Log in a user (web only)
  def log_in(user)
    session[:user_id] = user.id
  end
  # Log the current user out
  def log_out
    session[:user_id] = nil
  end

  # Check if the device is a mobile browser
  def mobile_device?
    if session[:mobile_param]
      session[:mobile_param] == "1"
    else
      request.user_agent =~ /Mobile|webOS/
    end
  end
  def mobile_status
    mobile_device? ? "is_mobile" : "is_desktop"
  end

  def image_set_tag(source, srcset = {}, options = {})
    srcset = srcset.map { |src, size| "#{path_to_image(src)} #{size}" }.join(', ')
    image_tag(source, options.merge(srcset: srcset))
  end

  def get_notification_text(notification)
    text = ActionTemplate[notification.action]
    text.sub!("#user_name#", notification.user.first_name) if text.include?("#user_name#")
    text.sub!("#actor_name#", notification.actor.first_name) if text.include?("#actor_name#")
    text.sub!("#activity_name#", notification.notifiable.name) if text.include?("#activity_name#")
    text.sub!("#group_name#", notification.notifiable.name) if text.include?("#group_name#")
    text.sub!("#service_name#", notification.notifiable.name) if text.include?("#service_name#")
    text.sub!("#professional_name#", notification.creator.first_name) if text.include?("#professional_name#")
    text.sub!("#buyer_name#", notification.actor.first_name) if text.include?("#buyer_name#")
    text.sub!("#rejection_reason#", notification.notifiable.reason) if text.include?("#rejection_reason#")
  end

end
