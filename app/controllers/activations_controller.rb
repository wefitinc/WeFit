class ActivationsController < ApplicationController
  #   Get the user
  before_action :get_user,   only: [:edit]
  #   Check the user is valid (and actiation token matches)
  before_action :valid_user, only: [:edit]

  def edit
  end

private
    def get_user
      @user = User.find_by(email: params[:email])
    end
    # Checks if the user exists and the activation token matches
    def valid_user
      unless (@user && @user.authenticated?(:activation, params[:id]))
        redirect_to root_path
      end
      # Mark the user as activated
      @user.activate!
    end
end
