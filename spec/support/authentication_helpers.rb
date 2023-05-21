module AuthenticationHelpers
  def get_auth_token(user)
    post '/api/v1/authenticate', params: { email: user.email, password: user.password }
    JSON.parse(response.body)['auth_token']
  end
end