json.extract! user, :id, :email, :provider, :uid, :first_name, :last_name, :created_at, :updated_at
json.url user_url(user, format: :json)