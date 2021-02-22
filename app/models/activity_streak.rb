class ActivityStreak < ApplicationRecord
  belongs_to :user

  after_create :inc_streak_counter
  after_update :update_streak_counter

  private

  def inc_streak_counter
  	if self.is_activity_done
  		self.user.update(activity_streak_counter: self.user.activity_streak_counter + 1)
  	else
  		self.user.update(activity_streak_counter: 0)
  	end
  end 

  def update_streak_counter
  	if self.is_activity_done
  		# recalculate the streak
  		bool_arr = self.user.activity_streaks.order(date: :desc).pluck(:is_activity_done)
  		streak_counter = 0
  		bool_arr.each do |bool_val|
  			streak_counter += 1 if bool_val
  			break unless bool_val
  		end
  		self.user.update(activity_streak_counter: streak_counter)
  	else
  		# updated from true to false
  		self.user.update(activity_streak_counter: 0)
  	end
  end

end
