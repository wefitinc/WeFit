class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  # Validate the comment body
  validates :body, 
  	presence: true, 
  	allow_blank: false, 
  	length: { maximum: 128 }

  # JSON serializer
  def as_json(*)
    super.except(
      "id", "post_id", "user_id",
      "created_at", "updated_at").tap do |hash|
        hash["user_id"] = user.hashid
      end
  end
end
