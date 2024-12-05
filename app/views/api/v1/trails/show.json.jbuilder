json.extract! @trail, :id, :title, :body

json.set! :comments do
  json.array! @trail.comments, partial: "api/v1/trails/comment", as: :comment
end