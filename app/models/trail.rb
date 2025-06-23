class Trail < ApplicationRecord
  belongs_to :fandom
  belongs_to :user
  belongs_to :profile

  validates :title, presence: true, length: { minimum: 3 }
  validates :fandom_id, presence: true
  validates :body, presence: true, length: { minimum: 10 }
  validates :user, presence: true

  has_many :comments, dependent: :destroy
  
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :likers, through: :likes, source: :user

  acts_as_taggable_on :tags
  acts_as_taggable_on :fandoms

  has_many :tag_selecteds
  has_many :tags, through: :tag_selecteds

  has_many :trail_points, dependent: :destroy
  accepts_nested_attributes_for :trail_points, allow_destroy: true

  has_many :trail_purchases
  has_many :buyers, through: :trail_purchases, source: :user
  has_many :purchasers, through: :trail_purchases, source: :user
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  has_many :finished_trails, dependent: :destroy
  has_many :favourite_trails, dependent: :destroy

  # доступ к пользователям
  has_many :users_finished, through: :finished_trails, source: :user
  has_many :users_favourited, through: :favourite_trails, source: :user
  has_many :users_purchased, through: :purchased_trails, source: :user

  # метод для обложки трейла
  def cover_image
    trail_points.first&.image_url
  end

  # метод для расчёта рейтинга (чтобы не забыть)
  def average_rating
    rated_comments = comments.where.not(rating_value: nil) # только комменты с оценками
    rated_comments.average(:rating_value).to_f.round(2) || 0
  end

  # количество отзывов
  def comments_count
    comments.count
  end

  # процентное соотношение положительных отзывов
  def positive_ratings_percentage
    rated_comments = comments.where.not(rating_value: nil) # только с оценками
    return 0 if rated_comments.empty?

    positive_ratings = rated_comments.where(rating_value: 4..5).count
    (positive_ratings.to_f / rated_comments.count * 100).round
  end

  # все отзывы с пользователями
  def ratings_with_users
    comments.includes(:user).where.not(rating_value: nil).map do |comment|
      {
        user_nickname: comment.user.profile.nickname,
        rating_value: comment.rating_value,
        created_at: comment.created_at
      }
    end
  end

  #метод для увеличения лайков
  def increment_likes
    update(likes_count: self.likes_count + 1)
  end

  #метод дизайлов
  def decrement_likes
    update(likes_count: [self.likes_count - 1, 0].max)
  end

  mount_uploader :image, TrailUploader 
  
  default_scope { order(created_at: "DESC") }

  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end

end