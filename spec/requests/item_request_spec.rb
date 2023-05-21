require "rails_helper"

RSpec.describe "Items" do
  let!(:item) { create(:item) }
  let!(:item2) { create(:item) }
  let!(:item3) { create(:item) }

  shared_examples "a user who can read items" do
    describe "GET /items" do
      it "returns all items" do
        get items_path, headers: { "Authorization" => @auth_token }
        parsed_body = JSON.parse(response.body)

        expect(parsed_body.count).to eq(3)
      end
    end
  end

  context "when user is authenticated" do
    before :each do
      @user = create(:user)
      @auth_token = get_auth_token(@user)
    end  

    it_behaves_like "a user who can read items"
  end
end