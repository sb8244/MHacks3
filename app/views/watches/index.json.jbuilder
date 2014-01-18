json.array!(@watches) do |watch|
  json.extract! watch, :id, :url, :selector, :user
  json.url watch_url(watch, format: :json)
end
