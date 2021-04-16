class PushNotification

  class << self
    def to_user(user_id, options)
      if $fcm.present?
        android_registration_ids = UserDeviceToken.where(user_id: user_id, device_type: UserDeviceToken.device_types[:android]).pluck(:token)
        ios_registration_ids = UserDeviceToken.where(user_id: user_id, device_type: UserDeviceToken.device_types[:ios]).pluck(:token)
        
        push_on_user_device(android_registration_ids, options[0]) if android_registration_ids.present?
        push_on_user_device(ios_registration_ids, options[1]) if ios_registration_ids.present?
      end
    end

    def push_on_user_device(registration_ids, options)
      response = $fcm.send(registration_ids, options)
      UserDeviceToken.where(token: response[:not_registered_ids]).delete_all if response[:not_registered_ids].present? rescue nil
    end

    def to_topic(topic, options)
      if $fcm.present?
        response = $fcm.send_to_topic(topic, options)
        UserDeviceToken.where(token: response[:not_registered_ids]).delete_all if response[:not_registered_ids].present? rescue nil
      end
    end

  end

end