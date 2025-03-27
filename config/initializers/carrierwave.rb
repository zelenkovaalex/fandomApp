CarrierWave.configure do |config|
  config.root = Rails.root.join('app', 'assets', 'images')
  config.cache_dir = "#{Rails.root}/tmp/uploads" 
end