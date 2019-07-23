class Api::V1::BaseController < ActionController::API
  def test
    render json: { status: 'ok'}
  end
end