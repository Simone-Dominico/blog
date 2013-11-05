json.array!(@articles) do |article|
  json.extract! article, :name, :content
  json.url article_url(article, format: :json)
end
