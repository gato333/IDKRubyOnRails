json.array!(@event_results) do |event_result|
  json.extract! event_result, :id
  json.url event_result_url(event_result, format: :json)
end
