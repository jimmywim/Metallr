class User < ActiveRecord::Base
  ROLES = %w[admin mod user banned]
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable


  attr_accessor :current_password

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :role,
          :current_password, :avatar

  # attr_accessible :title, :body

  validates :password, :presence => true, :on => :create 
  #validates_confirmation_of :password, :allow_blank => true, :on => :create 

  has_many :posts
  has_attached_file :avatar, 
    :styles => { :medium => "300x300>", :thumb => "50x50>>" }, 
    :default_url => ":style/default_avatar.png"



  # This bunch of methods handle user friendships using Redis.
  # Followers of a user = groupies
  # People that a user follows = idols

  # Add someone to my idols list
  #  - Also adds you to their groupies list
  def idolize!(user)
    $redis.multi do
      $redis.sadd(self.redis_key(:idols), user.id)
      $redis.sadd(user.redis_key(:groupies), self.id)
    end
  end

  # remove someone from my idols list
  #  - also removes you from their groupies list
  def unidolize!(user)
    $redis.multi do
      $redis.srem(self.redis_key(:idos), user.id)
      $redis.srem(user.redis_key(:groupies), self.id)
    end
  end

  # Gets the people in your idols list (people you follow)
  def idols 
    user_ids = $redis.smembers(self.redis_key(:idols))
    User.where(:id => user_ids)
  end

  # Gets the peoplein your groupies list (people who follow you)
  def groupies
    user_ids = $redis.smembers(self.redis_key(:groupies))
    User.where(:id => user_ids)
  end

  def idols_count
    $redis.scard(self.redis_key(:idols))
  end

  def groupies_count
    $redis.scard(self.redis_key(:groupies))
  end

  def idolized_by?(user)
    $redis.sismember(self.redis_key(:groupies), user.id)
  end

  def groupy?(user)
    $redis.sismember(self.redis_key(:idols), user.id)
  end

  # Utility funciton to get a redis key
  def redis_key(str)
    "user:#{self.id}:#{str}"
  end
end
