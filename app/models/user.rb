# app/models/user.rb
class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise  :database_authenticatable, :registerable, 
          :recoverable, :rememberable, :validatable, 
          :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :trails, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one :profile, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :trail_purchases
  has_many :purchased_trails, through: :trail_purchases, source: :trail
  
  has_many :favourite_trails, through: :likes, source: :likeable, source_type: 'Trail'

  has_many :finished_trails_records, class_name: 'FinishedTrail'
  has_many :finished_trails, through: :finished_trails_records, source: :trail

  after_create :create_profile

  has_many :notifications, dependent: :destroy

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

  def liked?(likeable)
    likes.exists?(likeable: likeable)
  end

  def like(likeable)
    likes.find_or_create_by!(likeable: likeable)
  end

  def unlike(likeable)
    likes.find_by(likeable: likeable)&.destroy
  end

  private

  def create_profile
    Profile.create(user: self) unless profile.present?
  end
  
end