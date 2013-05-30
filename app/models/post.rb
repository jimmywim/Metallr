class Post < ActiveRecord::Base
  attr_accessible :content

  belongs_to :user

  validates :content,	:presence => true, :length => { :maximum => 255, :too_long => "%{count} characters is the maximum." }

  $redis_key = "flagged_posts"

	def self.search(keyword)
		if keyword
			find(:all, :conditions => ['content LIKE ?', "%#{keyword}%"], :order => "created_at DESC")
		else
			find(:all)
		end
	end

	# flagging/reporting of posts
	# flag post for review
	def flag!
		$redis.sadd(self.redis_key, self.id)
	end

	# unflag post
	def unflag!
		$redis.srem(self.redis_key, self.id)
	end

	# is post flagged?
	def flagged?
		$redis.sismember($redis_key, self.id)
	end

	# get collection of flagged posts
	def self.flagged
		post_ids = $redis.smembers($redis_key)
		Post.where(:id => post_ids)
	end

	# log this riff into Redis so we can get trending topics
	def log_trending
		# strip out the noisewords/stopwords
		@unpunctuated_content = self.content.downcase.gsub(/[^a-z# ]/, '').scan(/(?:(?<=\s)|^)#(\.*[A-Za-z_]+\w*)/i).flatten

		logger.debug @unpunctuated_content
		#@words = @unpunctuated_content.split.delete_if{|x| $noise_words.include?(x.downcase)}

		unless ($redis.exists(self.redis_key_trending))
			$redis.zadd(self.redis_key_trending, 1, '')
			$redis.expire(self.redis_key_trending, 7200)
		end

		@unpunctuated_content.each do |hashtag|
			$redis.zincrby(self.redis_key_trending, 1, hashtag)
		end
		
	end

	# Utility funciton to get a redis key
	def redis_key
		"flagged_posts"
	end

	def redis_key_trending
		@curTimeStr = DateTime.current.strftime("%Y-%m-%d-%H")
		"trending_topics:#{@curTimeStr}"
	end
end
