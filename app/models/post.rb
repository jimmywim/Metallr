class Post < ActiveRecord::Base
  attr_accessible :content

  belongs_to :user

#  validates :content,	:presence => true

	def self.search(keyword)
		if keyword
			find(:all, :conditions => ['content LIKE ?', "%#{keyword}%"], :order => "created_at DESC")
		else
			find(:all)
		end
	end
end
