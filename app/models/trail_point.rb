class TrailPoint < ApplicationRecord
  belongs_to :trail
  mount_uploader :image_url, ImageUploader
end
