json.streak_counter       @user.activity_streak_counter
json.streak @streak do |streak|
	json.date								streak.date
	json.is_activity_done   streak.is_activity_done
end