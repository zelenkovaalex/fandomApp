class TrailImageUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :thumb do
    process resize_to_fill: [100, 100] # Вот тут определяем размер thumbnail
  end

  version :medium do
    process resize_to_fill: [300, 300] # А тут размер medium
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end
end