class Member < ApplicationRecord
  # Every member belongs to a group
  belongs_to :group, counter_cache: true
  # Every member represents a user
  belongs_to :user
end
