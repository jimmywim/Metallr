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
          :current_password
  # attr_accessible :title, :body

  validates :password, :presence => true, :on => :create 
  #validates_confirmation_of :password, :allow_blank => true, :on => :create 

  has_many :posts
end
