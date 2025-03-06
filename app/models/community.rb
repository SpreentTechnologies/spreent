class Community < ApplicationRecord
  belongs_to :sport
  belongs_to :admin, class_name: :User
  has_many :community_memberships
  has_many :members, through: :community_memberships, source: :user
  has_many :challenges

  validates :name, presence: true
  validates :sport, presence: true
  validates :location, presence: true
  validates :description, presence: true

  has_one_attached :banner

  has_one_attached :image

  def display_image
    if image.attached?
      image
    else
      # Return a path to a placeholder image
      "/images/community-placeholder.png"
    end
  end
end
