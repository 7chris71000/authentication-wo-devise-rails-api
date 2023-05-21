require "mock_redis"

RSpec.describe "Items" do
  shared_examples "a user who can read items" do
    describe "GET /items" do
      it "returns all items, description nil when no password is provided" do
        get items_path,
          params: {
            format: :json,
          },
          headers: {
            "Authorization" => @auth_token,
          }
        parsed_body = JSON.parse(response.body)

        parsed_body.each do |item|
          expect(item["description"]).to eq(nil)
        end
      end

      it "returns all items, description nil when incorrect password is provided" do
        get items_path,
            params: {
              encrypt_password: "incorrect password",
              format: :json,
            },
            headers: {
              "Authorization" => @auth_token,
            }
        parsed_body = JSON.parse(response.body)

        parsed_body.each do |item|
          expect(item["description"]).to eq(nil)
        end
      end

      it "returns all items, description present when correct password is provided" do
        get items_path,
            params: {
              encrypt_password: "password",
              format: :json,
            },
            headers: {
              "Authorization" => @auth_token,
            }
        parsed_body = JSON.parse(response.body)

        parsed_body.each do |item|
          expect(item["description"]).to_not eq(nil)
        end
      end

      it "returns error when rate limit reached" do
        redis = MockRedis.new
        allow(Redis).to receive(:new).and_return(redis)

        5.times do
          get items_path,
              params: {
                encrypt_password: "password",
                format: :json,
              },
              headers: {
                "Authorization" => @auth_token,
              }

          expect(response.status).to eq(200)
        end

        get items_path,
            params: {
              encrypt_password: "password",
              format: :json,
            },
            headers: {
              "Authorization" => @auth_token,
            }

        expect(response.status).to eq(429)
      end
    end
  end

  shared_examples "a user who can manage items" do
    describe "POST /items" do
      it "creates an item" do
        post items_path,
             params: {
               item: {
                 name: "Item 1",
                 price_cents: 199,
                 description: "This is an item description.",
               },
               encrypt_password: "password",
               format: :json,
             },
             headers: {
               "Authorization" => @auth_token,
             }

        parsed_body = JSON.parse(response.body)

        expect(parsed_body["name"]).to eq("Item 1")
      end
    end

    describe "DELETE /items/:id" do
      it "deletes an item and returns all other existing items" do
        delete "/items/#{@item_1["id"]}",
               params: {
                 encrypt_password: "password",
                 format: :json,
               },
               headers: {
                 "Authorization" => @auth_token,
               }

        parsed_body = JSON.parse(response.body)

        parsed_body.each do |item|
          expect(item["id"]).to_not eq(@item_1["id"])
        end
      end
    end
  end

  shared_examples "a user who can not read items" do
    describe "GET /items" do
      it "returns all items, description nil when no password is provided" do
        get items_path,
          params: {
            format: :json,
          },
          headers: {
            "Authorization" => @incorrect_auth_token,
          }

        expect(response.status).to eq(401)
      end

      it "returns all items, description nil when incorrect password is provided" do
        get items_path,
            params: {
              encrypt_password: "incorrect password",
              format: :json,
            },
            headers: {
              "Authorization" => @incorrect_auth_token,
            }

        expect(response.status).to eq(401)
      end

      it "returns all items, description present when correct password is provided" do
        get items_path,
            params: {
              encrypt_password: "password",
              format: :json,
            },
            headers: {
              "Authorization" => @incorrect_auth_token,
            }

        expect(response.status).to eq(401)
      end
    end
  end

  shared_examples "a user who can not manage items" do
    describe "POST /items" do
      it "does not create an item" do
        post items_path,
             params: {
               item: {
                 name: "Item 1",
                 price_cents: 199,
                 description: "This is an item description.",
               },
               encrypt_password: "password",
               format: :json,
             },
             headers: {
               "Authorization" => @incorrect_auth_token,
             }

        expect(response.status).to eq(401)
      end
    end

    describe "DELETE /items/:id" do
      it "deletes an item and returns all other existing items" do
        delete "/items/#{@item_1["id"]}",
               params: {
                 encrypt_password: "password",
                 format: :json,
               },
               headers: {
                 "Authorization" => @incorrect_auth_token,
               }

        expect(response.status).to eq(401)
      end
    end
  end

  context "when user is authenticated" do
    before :each do
      @user = create(:user)
      @auth_token = get_auth_token(@user)
      @item_1 = create_item(
        {
          name: "Item 1",
          price_cents: 199,
          description: "This is an item description 1.",
        },
        @auth_token
      )
      @item_2 = create_item(
        {
          name: "Item 2",
          price_cents: 199,
          description: "This is an item description 2.",
        },
        @auth_token
      )
    end

    it_behaves_like "a user who can read items"
    it_behaves_like "a user who can manage items"
  end

  context "when user is not authenticated" do
    before :each do
      @user = create(:user)
      @auth_token = get_auth_token(@user)
      @incorrect_auth_token = "Incorrect Auth Token"
      @item_1 = create_item(
        {
          name: "Item 1",
          price_cents: 199,
          description: "This is an item description 1.",
        },
        @auth_token
      )
      @item_2 = create_item(
        {
          name: "Item 2",
          price_cents: 199,
          description: "This is an item description 2.",
        },
        @auth_token
      )
    end

    it_behaves_like "a user who can not read items"
    it_behaves_like "a user who can not manage items"
  end
end
