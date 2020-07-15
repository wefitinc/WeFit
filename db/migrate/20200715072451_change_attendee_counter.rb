class ChangeAttendeeCounter < ActiveRecord::Migration[5.2]
  def change
  	rename_column :activities, :attendee_count, :attendees_count
  end
end
