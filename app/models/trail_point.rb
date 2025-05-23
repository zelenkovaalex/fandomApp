class TrailPoint < ApplicationRecord
  belongs_to :trail
  mount_uploader :image, TrailUploader
end
