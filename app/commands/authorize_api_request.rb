class AuthorizeApiRequest
  prepend SimpleCommand
  attr_reader :headers # we only want to be able to read the values from the header

  def initialize(headers = {})
    @headers = headers
  end

  def call
    user
  end

  private

  def http_auth_header
    if headers["Authorization"].present?
      return headers["Authorization"].split(" ").last
    else
      errors.add(:token, "Missing token")
    end
  end

  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  def user
    if decoded_auth_token
      @user ||= User.find(@decoded_auth_token[:user_id])
    end

    if @user.present?
      return @user
    else
      errors.add(:token, "Invalid token")
      return nil
    end
  end
end
