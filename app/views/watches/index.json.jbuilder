json.array!(@watches) do |watch|
  json.extract! watch, :id, :url, :selector
  json.url watch_url(watch, format: :json)
end
