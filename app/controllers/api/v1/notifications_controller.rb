class Api::V1::NotificationsController < Api::V1::BaseController

  before_action :authorize, only: [:index, :mute, :unmute, :get_settings, :delete, :settings]
  before_action :set_activity, only: [:destroy]

  # GET /notifications
  # Params: {page: <int>}
  # Get a list of notifications
  def index
    @notifications = Notification.where(user_id: @current_user.id).page(@page_param)
  end

  # POST /notifications/mute
  # Params: {time: <hr>}
  def mute
    NotificationSetting.where(user_id: @current_user.id).last.update( 
      unmute_at: Time.now.in_time_zone + params[:hr].to_i.hours)
    render 'get_settings'
  end

  # POST /notifications/unmute
  def unmute
    NotificationSetting.where(user_id: @current_user.id).last.update(unmute_at: Time.now.in_time_zone)
    render 'get_settings'
  end

  # POST /notifications/delete
  # Params: {ids: <array of notification ids to be deleted>}
  def delete
    validate_owner
    Notification.where(id: params[:ids]).update_all(is_deleted: true)
    render json: { message: "Notification(s) deleted" }
  end

  # GET /notifications/settings
  def get_settings
    @setting = NotificationSetting.where(user_id: @current_user.id).last
    unless @setting.present?
      @setting = NotificationSetting.create(user_id: @current_user.id, mute_likes: false, mute_comments: false, 
        mute_followers: false, mute_activities: false, mute_groups: false, mute_messages: false, 
        mute_exercise_reminders: false, mute_motivation_messages: false, mute_professionals: false, 
        mute_emails: false)
    end
  end

  # POST /notifications/settings
  def settings
    if NotificationSetting.where(user_id: @current_user.id).exists?
      @setting = NotificationSetting.where(user_id: @current_user.id).last.update(notification_settings_params)
    else
      settings_params = notification_settings_params.merge!({user_id: @current_user.id})
      @setting = NotificationSetting.create(settings_params)
    end
    render 'get_settings'
  end

  private

  def set_notification
    @notification = Notification.find(params[:id])
    render json: { errors: "Not found" }, status: 404 if @activity.nil?
  end

  def validate_owner
    owner_ids = Notification.where(id: params[:ids]).pluck(:user_id).uniq
    render json: { errors: "You are not authorized to do this action." }, status: :unauthorized if (owner_ids - [@current_user.id]).present?
  end

  def notification_settings_params
    params.require(:notification_settings).permit(
      :mute_likes,
      :mute_comments,
      :mute_followers,
      :mute_activities,
      :mute_groups,
      :mute_messages,
      :mute_exercise_reminders,
      :mute_motivation_messages,
      :mute_professionals,
      :mute_emails
    )
  end

end
