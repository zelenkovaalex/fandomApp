# app/models/user.rb
class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise  :database_authenticatable, :registerable, 
          :recoverable, :rememberable, :validatable, 
          :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :trails, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one :profile, dependent: :destroy
  has_many :likes

  after_create :create_profile

  # has_secure_password

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

  def jwt_payload
    {
      email: self.email,
      jti: self.jti
    }
  end
end