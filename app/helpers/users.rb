helpers do
  def authenticated?
    !session[:oauth_token].nil?
  end

  def current_user
    @current_user ||= User.new(session[:user_attributes])
  end

  def authenticate!
    redirect '/' unless authenticated?
  end
end
