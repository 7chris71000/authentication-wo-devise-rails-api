attributes :id,
           :name,
           :price_cents,
           :created_at,
           :updated_at

node :description do |item|
  if item.encrypt_password.present?
    item.decrypt_value("description", item.encrypt_password)
  else
    nil
  end
end
