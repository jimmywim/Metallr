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

	# Utility funciton to get a redis key
	def redis_key
		"flagged_posts"
	end
end
