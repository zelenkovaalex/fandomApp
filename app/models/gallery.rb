class Gallery < ApplicationRecord
  belongs_to :trail
  has_many_attached :images
end
