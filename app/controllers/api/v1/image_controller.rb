class Api::V1::ImagesController < ApplicationController
  before_action :authenticate_user!

  def create
    image = params[:image]

    if image && image.content_type.start_with?('image/')
      processed_image = process_image(image)

      # Attach processed image to current_user's avatar (ActiveStorage)
      current_user.avatar.attach(
        io: processed_image,
        filename: image.original_filename,
        content_type: image.content_type
      )

      # Get the URL for the uploaded avatar
      url = url_for(current_user.avatar) if current_user.avatar.attached?

      render json: { message: 'Изображение успешно загружено и обработано!', url: url }, status: :ok
    else
      render json: { error: 'Неверный файл' }, status: :unprocessable_entity
    end
  end

  private

  def process_image(image)
    processed_image = MiniMagick::Image.read(image.read)
    processed_image.resize '300x300'
    StringIO.new(processed_image.to_blob)
  end
end