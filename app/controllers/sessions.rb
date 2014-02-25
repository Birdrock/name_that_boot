use OmniAuth::Builder do
  provider :dbc, ENV['OAUTH_CLIENT_ID'], ENV['OAUTH_CLIENT_SECRET']
end

get '/sign_in' do
  redirect to ('/auth/dbc')
end

get '/auth/:provider/callback' do
  @current_user =  User.create_or_find_user_from_oauth(request.env['omniauth.auth'].info)
  session[:user_id] = @current_user.id
  token = request.env['omniauth.auth'].credentials
  session[:oauth_token] = token_as_hash(token)
  redirect to ('/game')
end

get '/sign_out' do
  #add an ajax hook that will make a call out to auth.devbootcamp.com/unauthenticate
  session.clear
  redirect to ('/')
end