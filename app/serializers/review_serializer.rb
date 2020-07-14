class ReviewSerializer < ActiveModel::Serializer
  has_one :user
  has_one :reviewer

  attributes :reviewer, 
    :stars,
    :text,
    :created_at, :updated_at
end
