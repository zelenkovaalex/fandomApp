class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :trails, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one :profile
  has_many :likes

  after_create :create_profile

end
 