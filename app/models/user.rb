# app/models/user.rb
class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise  :database_authenticatable, :registerable, 
          :recoverable, :rememberable, :validatable, 
          :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :trails
  has_many :comments, dependent: :destroy
  has_one :profile, dependent: :destroy
  has_many :likes

  after_create :create_profile

  # validates :email, presence: true, uniqueness: true

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

  def like(likeable)
    likes.where(likeable: likeable).first_or_create
  end

  def unlike(likeable)
    likes.where(likeable: likeable).destroy_all
  end

  def liked?(likeable)
    likes.exists?(likeable: likeable)
  end
  
end