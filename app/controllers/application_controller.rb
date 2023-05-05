class ApplicationController < ActionController::API
  before_action :authenticate_request
  attr_reader :current_user

  private

  def authenticate_request
    # request.headers is provided by rails
    @current_user = AuthorizeApiRequest.call(request.headers).result
    if !@current_user
      render json: { error: "Not Authorized" }, status: 401
    end
  end
end
