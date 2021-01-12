class Participant < ApplicationRecord
	belongs_to :activity
  belongs_to :user

  # The activity must exist
  validates :activity,
    presence: true
  # Users must exist and be unique
  validates :user,
    presence: true,
    uniqueness: { scope: :activity }

  after_create :update_participants_counter_on_create
  after_update :update_participants_counter_on_update

  private

  def update_participants_counter_on_create
  	if is_attending
  		activity.update(attendees_count: activity.attendees_count + 1)
  	else
  		activity.update(absentees_count: activity.absentees_count + 1)
  	end
  end

  def update_participants_counter_on_update
  	if is_attending
  		activity.update(attendees_count: activity.attendees_count + 1, absentees_count: activity.absentees_count - 1)
  	else
  		activity.update(attendees_count: activity.attendees_count - 1, absentees_count: activity.absentees_count + 1)
  	end
  end

end
