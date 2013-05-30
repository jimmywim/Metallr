class TrendingController < ApplicationController
	def topics
		@curTimeStr = DateTime.current.strftime("%Y-%m-%d-%H")
		@redis_cur_trending_key = "trending_topics:#{@curTimeStr}"

		@prevTimeStr = (DateTime.current - 5.hours).strftime("%Y-%m-%d-%H")
		@redis_prev_trending_key = "trending_topics:#{@prevTimeStr}"

		$redis.zunionstore("trending_topics:current", 
			[@redis_cur_trending_key, @redis_prev_trending_key])

		@topics = $redis.zrevrange("trending_topics:current", 0, 9)

		logger.debug @topics.count

		respond_to do |format|
			format.js
			format.json { render :json => { :success => "true", :data => @topics } }
		end
	end
end
