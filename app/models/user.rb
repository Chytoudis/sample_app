class User < ActiveRecord::Base
	#create a self mail downcase
  before_save { self.email = email.downcase }
  	#create a remember token
  before_create :create_remember_token
  	#validates the presence of a name and the max length 50
  validates :name, presence: true, length: { maximum: 50 }
  	#regular expression for valid email format
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  	#validates the presence, uniqueness and format of email
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
             uniqueness: { case_sensitive: false }
  	#rails method to secure password machinery
  has_secure_password
  	#validates password with minimum length 
  validates :password, length: { minimum: 6 }

 #***** CLASS METHODS (do not require user instance to work)

  	#method that adds to user remember token NOT blank
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end
  	#method for digesting token to string using SHA1 hash protocol
  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end	

  private
  	#private method creating remember token for a user
    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end	
end