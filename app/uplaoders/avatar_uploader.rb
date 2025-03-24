class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file
  
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :thumb do
    process resize_to_fill: [200, 200]
  end

  version :medium do
    process resize_to_fill: [400, 400]
  end

  def extension_allowlist
    %w[jpg jpeg png]
  end
end