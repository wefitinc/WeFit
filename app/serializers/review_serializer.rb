class ReviewSerializer < ActiveModel::Serializer
  has_one :user
  has_one :professional

  attributes
    :user, 
    :stars,
    :text,
    :created_at, :updated_at
end
