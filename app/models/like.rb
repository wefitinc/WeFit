class Like < ApplicationRecord
  # Likes belong to an object (the thing being 'liked') and have users
  belongs_to :user
  belongs_to :owner, 
    polymorphic: true,
    counter_cache: true
  # Users must exist and be unique
  validates :user,
    presence: true,
    uniqueness: { scope: :owner }

  after_commit :after_like_processes, on: :create
  after_commit :dec_post_score, on: :destroy

  private 

  def after_like_processes
    inc_post_score
    relay_notification
  end

  def inc_post_score
  	if self.owner_type == "Post"
  		self.owner.update(score: self.owner.score + LikeValue)
  	end
  end

  def dec_post_score
  	if self.owner_type == "Post"
  		self.owner.update(score: self.owner.score - LikeValue)
  	end
  end

  def relay_notification
    # if self.owner_type == "Post" 
    #   unless self.user_id == self.owner.user_id
    #     obj_params = {user_id: self.owner.user_id, actor_id: self.user_id, creator_id: self.owner.user_id, 
    #       notifiable_id: self.id, notifiable_type: "Like", action: Notification.actions[:like]}
    #     NotificationProcessingService.perform(obj_params)
    #   end
    # end
  end

end
