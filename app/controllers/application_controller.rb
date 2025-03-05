class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :authenicate_guest

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to root_path, alert: exception.message }
    end
  end

  def authenicate_guest
    if current_user
      if cookies[:guest_token]
        puts cookies[:guest_token] == current_user.jti
      else
        cookies[:guest_token] = current_user.jti
      end
    end
  end

  protected

  def authenticate_user_from_token!
    auth_header = request.headers['Authorization']
    token = auth_header&.split(' ')&.last
    payload = JWT.decode(token, Rails.application.credentials.devise_jwt_secret_key!, true, { algorithm: 'HS256' }).first rescue nil

    if payload && payload['email']
      @current_user = User.find_by(email: payload['email'])
    end

    render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
  end

  def set_locale
    loc = extract_locale

    unless loc.nil?
      I18n.locale = loc
      cookies[:locale] = loc
    end
  end

  def extract_locale
    if !params[:locale].blank?
      parsed_locale = params[:locale]
    elsif !cookies[:locale].blank?
      parsed_locale = cookies[:locale]
    elsif !request.env['HTTP_ACCEPT_LANGUAGE'].blank?
      parsed_locale = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/)[0]
    else
      return nil
    end

    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end
end