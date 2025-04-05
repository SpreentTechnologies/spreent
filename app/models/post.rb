class Post < ApplicationRecord
  has_many_attached :media
  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user
  has_many :reports, dependent: :destroy
  belongs_to :user
  belongs_to :challenge

  validates :content, length: {minimum: 1, maximum: 100}, presence: true

  has_many_attached :media do |attachable|
    attachable.variant :thumb, resize_to_limit: [300, 300]
    attachable.variant :preview, resize_to_limit: [600, 600]
  end

  scope :with_media, -> { joins_attached_media }

  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end
end
