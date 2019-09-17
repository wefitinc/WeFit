class ActivationsController < ApplicationController
  #   Get the user
  before_action :get_user,   only: [:new, :edit]
  #   Check the user is valid (and actiation token matches)
  before_action :valid_user, only: [:edit]

  def new
    # Resend the activation email
    @user.create_activation_digest
    @user.send_activation_email
    # Go back home
    redirect_to root_path
  end

  def edit
    # Mark the user as activated
    @user.activate!
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
    end
end
