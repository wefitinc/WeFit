class AddAttendeeCounterToActivities < ActiveRecord::Migration[5.2]
  def change
  	add_column :activities, :attendee_count, :integer, default: 0
  end
end
