#Authentication elements

module SessionsHelper

  def sign_in(user)
  	#create new token
    remember_token = User.new_remember_token
    #place the token in the browser cookies
    cookies.permanent[:remember_token] = remember_token
    #save the hashed token to the database
    user.update_attribute(:remember_token, User.digest(remember_token))
    #set current user equal to the given user
    self.current_user = user
  end
    #if current_user non nil a user is signed in
  def signed_in?
    !current_user.nil?
  end

    #special syntax in ror that defines the assignment function: self.current_user = user
  def current_user=(user)
    @current_user = user
  end

    #when the user makes a second request, all the variables get set to their defaults, 
    #which for instance variables like @current_user is nil. Therefore, 
  def current_user
    #token is hashed in db, so we hash the token first
    remember_token = User.digest(cookies[:remember_token])
    #sets the instance variable to the user corresponding to the remember token,
    #only if the @current_user is undefined
    @current_user ||= User.find_by(remember_token: remember_token)
    #calls the find_by method the first time current_user is called, 
    #but on subsequent invocations returns @current_user without hitting the database
  end

  def sign_out
    #we first change the user’s remember token in the database 
    #in case the cookie has been stolen, as it could still be used to authorize a user
    current_user.update_attribute(:remember_token,
                                  User.digest(User.new_remember_token))
    #remove the remember token from the session
    cookies.delete(:remember_token)
    #optionally we set the current user to nil
    self.current_user = nil
  end
end
