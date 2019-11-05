class Api::V1::BaseController < ActionController::API
  # Include the base helper functions in every controller
  include Api::V1::BaseHelper

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
 
  private
    def record_not_found
      render json: { error: "404 Not Found", status: 404 }, status: 404
    end
end
