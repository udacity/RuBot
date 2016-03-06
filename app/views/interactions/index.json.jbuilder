json.array!(@interactions) do |interaction|
  json.extract! interaction, :id, :user_input, :response
  json.url interaction_url(interaction, format: :json)
end
