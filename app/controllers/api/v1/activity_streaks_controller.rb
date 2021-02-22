class Api::V1::ActivityStreaksController < Api::V1::BaseController
  before_action :authorize

  # POST /:user/:id/activity_streak
  # Params: {is_activity_done: true, date: <date>}
  def create
    @streak = @current_user.activity_streaks.where(date: params[:date]).first
    if @streak.present?
      @streak.update!(date: params[:date], is_activity_done: params[:is_activity_done]) unless 
        @streak.is_activity_done == params[:is_activity_done]
    else
      ActivityStreak.create!(user_id: @current_user.id, date: params[:date], is_activity_done: params[:is_activity_done])
    end
    render json: { message: "Success!" }
  end

end
