json.extract! comment, :id, :body, :pin_id, :created_at, :updated_at
json.url comment_url(comment, format: :json)