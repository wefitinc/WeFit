class Like < ApplicationRecord
  belongs_to :post
  belongs_to :user

  # JSON serializer
  def as_json(*)
    super.except(
      "id", "post_id", "user_id",
      "created_at", "updated_at").tap do |hash|
        hash["user_id"] = user.hashid
      end
  end
end
