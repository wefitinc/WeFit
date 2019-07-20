module ApplicationHelper
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
end
