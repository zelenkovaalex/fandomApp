# app/models/user.rb
class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise  :database_authenticatable, :registerable, 
          :recoverable, :rememberable, :validatable, 
          :jwt_authenticatable, jwt_revocation_strategy: self

  belongs_to :trail
  has_many :trails, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one :profile
  has_many :likes
end