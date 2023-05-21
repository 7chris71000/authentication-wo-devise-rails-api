require "rails_helper"

RSpec.describe "Authentication", type: :request do 
  describe "POST /authenticate" do
    let(:user) { create(:user) }
    let(:valid_credentials) do
      {
        email: user.email,
        password: user.password
      }
    end
    let(:invalid_credentials) do
      {
        email: user.email,
        password: "invalid"
      }
    end

    context "when request is valid" do
      it "returns an authentication token" do
        post authenticate_path, params: valid_credentials
        parsed_body = JSON.parse(response.body)

        expect(parsed_body.try(:[], "auth_token")).not_to be_nil
      end
    end

    context "when request is invalid" do
      it "returns a failure message" do
        post authenticate_path, params: invalid_credentials
        parsed_body = JSON.parse(response.body)

        expect(parsed_body.try(:[], "error").try(:[], "user_authentication")).to match(/invalid credentials/)
      end
    end
  end
end