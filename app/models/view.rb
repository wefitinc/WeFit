class View < ApplicationRecord
  # Views are on posts and have users
  belongs_to :user
  belongs_to :post
  # The post must exist
  validates :post,
    presence: true
  # Users must exist and be unique
  validates :user,
    presence: true,
    uniqueness: { scope: :post }

  # JSON serializer
  def as_json(*)
    super.except(
      "id", "post_id", "user_id",
      "created_at", "updated_at").tap do |hash|
        hash["user_id"] = user.hashid
      end
  end
end
