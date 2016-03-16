json.array!(@logs) do |log|
  json.extract! log, :id, :channel_id, :message_id, :delivery_time
  json.url log_url(log, format: :json)
end
