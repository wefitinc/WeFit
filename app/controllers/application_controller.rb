class ApplicationController < ActionController::Base
  helper_method :current_user

  # Helper, allow pages to access the current user and get their information
  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    else
      @current_user = nil
    end
  end
end
