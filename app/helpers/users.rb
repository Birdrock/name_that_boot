helpers do
  def authenticated?
    !session[:oauth_token].nil?
  end

  def current_user
    @current_user ||= User.find(session[:user_id])
  end

  def authenticate!
    redirect '/' unless authenticated?
  end
end
