class Community < ApplicationRecord
  belongs_to :sport
  belongs_to :admin, class_name: :User
  has_many :memberships
  has_many :members, through: :memberships, source: :user
  has_many :challenges
  has_many :posts, dependent: :destroy

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

  def invite_user(user, invited_by)
    Notification.create_notification(
      recipient: user,
      actor: invited_by,
      notifiable: self,
      category: :invitation,
      message: "#{invited_by.name} has invited you to join the '#{name}' community."
    )
  end

  def owns?(user)
    user && user.id == admin_id
  end
end
