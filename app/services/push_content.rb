class PushContent

  class << self
    
    def notification_content(notification, *args)
      android_msg = {
        priority: args[0],
        data: {
          title: 'Notification',
          notify_type: notification.notify_type,
          notify_subtype: notification.notify_subtype,
          notification_text: "##{notification.actor.name}# #{notification.template}",
          obj_id: notification.obj_id,
          obj_class: notification.obj_class,
          obj_image_url: notification.obj_image_url,
          click_action: "NOTIFICATION_CLICK"
          # actor_id: notification.actor_id
          # actor_avatar: notification.actor.avatar_url
          # obj_image_url: args[1]
        },
        notification: {
          title: 'Notification',
          body: "##{notification.actor.try(:name)}# #{notification.template}"
        }
      }
      ios_msg = {
        priority: args[0],
        data: {
          title: 'Notification',
          notify_type: notification.notify_type,
          notify_subtype: notification.notify_subtype,
          notification_text: "##{notification.actor.name}# #{notification.template}",
          obj_id: notification.obj_id,
          obj_class: notification.obj_class,
          obj_image_url: notification.obj_image_url,
          click_action: "NOTIFICATION_CLICK"
          # actor_id: notification.actor_id
          # actor_avatar: notification.actor.avatar_url
          # obj_image_url: args[1]
        },
        notification: {
          title: 'Notification',
          body: "##{notification.actor.try(:name)}# #{notification.template}",
          sound: "default"
        }
      }
      return [android_msg, ios_msg]
    end

    def general_announcement(text)
      # android_msg = {
      #   data: {
      #     actor_id: nil,
      #     actor_avatar: nil,
      #     actor_name: nil,
      #     actor_penname: nil,
      #     text: text,
      #     story_id: nil,
      #     picture_id: nil,
      #     picture_url_thumb: nil,
      #     notification_type_id: GeneralAnnounementTypeId
      #   }
      # }
      # ios_msg = {}
      # [android_msg, ios_msg]
    end

  end

end