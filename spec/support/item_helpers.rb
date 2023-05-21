module ItemHelpers
  def create_item(item_params, auth_token)
    post items_path,
         params: {
           item: item_params,
           encrypt_password: "password",
           format: :json,
         },
         headers: {
           "Authorization" => @auth_token,
         }

    return JSON.parse(response.body)
  end
end
