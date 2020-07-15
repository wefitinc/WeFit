class Attendee < ApplicationRecord
  belongs_to :activity, counter_cache: true
  belongs_to :user

  # The activity must exist
  validates :activity,
    presence: true
  # Users must exist and be unique
  validates :user,
    presence: true,
    uniqueness: { scope: :activity }
end
