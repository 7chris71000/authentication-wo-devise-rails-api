class ApplicationController < ActionController::API
  before_action :authenticate_request
  attr_reader :current_user

  private
    def authenticate_request
      # request.headers is provided by rails
      authorize_api_request = AuthorizeApiRequest.call(request.headers) 
      if authorize_api_request.errors.present?
        request_errors = authorize_api_request.errors

        if request_errors[:token].present?
          render json: { error: request_errors[:token] }, status: 401
        elsif request_errors[:rate_limit].present?
          render json: { error: request_errors[:rate_limit] }, status: 429
        else
          render json: { error: "Not Authorized" }, status: 401
        end
      else
        @current_user = authorize_api_request.user
      end
    end
end
