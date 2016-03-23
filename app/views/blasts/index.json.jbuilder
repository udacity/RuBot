json.array!(@blasts) do |blast|
  json.extract! blast, :id, :text, :reach
  json.url blast_url(blast, format: :json)
end
