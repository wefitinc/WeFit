class DropTableAttendees < ActiveRecord::Migration[5.2]
  def change
  	drop_table :attendees
  end
end
