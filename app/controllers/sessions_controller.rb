class SessionsController < ApplicationController
  def new
  end

  def create
    auth_hash = request.env['omniauth.auth']
    @authorization = Authorization.find_user_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
    
  end

  def failure
  end
end
