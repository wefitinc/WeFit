class Analysis < ApplicationRecord


	def populate_daily_data
		last_day = Analysis.order(created_at: :desc).last.try(:day) || 0
		day = last_day + 1
		last_week = Analysis.order(created_at: :desc).last.try(:week) || 0
		week = Time.now.wday == 4 ? last_week + 1 : (last_week == 0 ? 1 : last_week)
		users_count = User.where("created_at > ? && created_at < ?", Time.parse("#{Date.yesterday.to_s} 09:00:00"), 
			Time.parse("#{Date.today.to_s} 08:59:59")).count
		posts_count = Post.where("created_at > ? && created_at < ?", Time.parse("#{Date.yesterday.to_s} 09:00:00"), 
			Time.parse("#{Date.today.to_s} 08:59:59")).count
		activities_count = Activity.where("created_at > ? && created_at < ?", Time.parse("#{Date.yesterday.to_s} 09:00:00"), 
			Time.parse("#{Date.today.to_s} 08:59:59")).count
		groups_count = Group.where("created_at > ? && created_at < ?", Time.parse("#{Date.yesterday.to_s} 09:00:00"), 
			Time.parse("#{Date.today.to_s} 08:59:59")).count
		members_count = Member.where("created_at > ? && created_at < ?", Time.parse("#{Date.yesterday.to_s} 09:00:00"), 
			Time.parse("#{Date.today.to_s} 08:59:59")).count
		Analysis.create(users_count: users_count, posts_count: posts_count, activities_count: activities_count, 
			groups_count: groups_count, groups_joined_count: members_count, day: day, week: week)
	end

end
