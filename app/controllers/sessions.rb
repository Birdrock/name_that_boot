use OmniAuth::Builder do
  provider :dbc, ENV['OAUTH_CLIENT_ID'], ENV['OAUTH_CLIENT_SECRET']
end

get '/sign_in' do
  redirect to ('/auth/dbc')
end

get '/auth/:provider/callback' do
  user_attributes = request.env['omniauth.auth'].info
  session[:user_attributes] = user_attributes
  token = request.env['omniauth.auth'].credentials
  session[:oauth_token] = token_as_hash(token)
  redirect to ('/game')
end

get '/sign_out' do
  #add an ajax hook that will make a call out to auth.devbootcamp.com/unauthenticate
  session.clear
  redirect to ('/')
end