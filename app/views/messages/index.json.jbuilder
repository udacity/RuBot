json.array!(@messages) do |message|
  json.extract! message, :id, :message_number, :text, :project
  json.url message_url(message, format: :json)
end
