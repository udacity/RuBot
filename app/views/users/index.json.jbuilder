json.array!(@users) do |user|
  json.extract! user, :id, :user_name, :real_name, :slack_id, :email
  json.url user_url(user, format: :json)
end
