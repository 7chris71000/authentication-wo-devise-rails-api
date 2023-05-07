class AuthenticateUser
  prepend SimpleCommand
  attr_accessor :email, :password

  def initialize(email, password)
    # this is where parameters are taken when the command is called
    @email = email
    @password = password
  end

  def call
    # this is where the result gets returned
    JsonWebToken.encode(user_id: user.id) if user
  end

  private

    def user
      user = User.find_by_email(email)
      if user && user.authenticate(password)
        return user
      else
        errors.add(:user_authentication, 'invalid credentials')
        return nil
      end
    end
end