class Post < ActiveRecord::Base
  attr_accessible :content

  belongs_to :user

  validates :content,	:presence => true, :length => { :maximum => 255, :too_long => "%{count} characters is the maximum." }

	def self.search(keyword)
		if keyword
			find(:all, :conditions => ['content LIKE ?', "%#{keyword}%"], :order => "created_at DESC")
		else
			find(:all)
		end
	end
end
