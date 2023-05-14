class AuthorizeApiRequest
  prepend SimpleCommand
  attr_reader :headers, :user # we only want to be able to read the values from the header

  def initialize(headers = {})
    @headers = headers
    @user = nil
  end

  def call
    puts "TEST\n\n\n\n\n\n\n\n"
    get_user
    verify_rate_limit
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

  def get_user
    if decoded_auth_token
      @user ||= User.find(@decoded_auth_token[:user_id])
    end

    if !@user.present?
      errors.add(:token, "Invalid token")
    end
  end

  def verify_rate_limit
    # use redis to store the number of requests per headers["Authorization"]
    # if the number of requests is greater than 1000, return an error
    puts "TEST\n\n\n\n\n\n\n\n"
    redis = Redis.new(host: "0.0.0.0", port: 6379)


    if redis.get(headers["Authorization"])
      if redis.get(headers["Authorization"]).to_i > 5
        errors.add(:rate_limit, "Rate limit exceeded. Try again in #{redis.ttl(headers["Authorization"])} seconds")
      else
        redis.incr(headers["Authorization"])
      end
    else
      puts "\n setting redis key at time: #{Time.now} for key #{headers["Authorization"]} \n\n"
      redis.set(headers["Authorization"], 1)
      redis.expire(headers["Authorization"], 60) # expire in 60 seconds
    end
  end
end
