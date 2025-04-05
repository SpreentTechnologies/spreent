class Challenge < ApplicationRecord
  belongs_to :community
  belongs_to :user, class_name: "User"

  has_many :notifications, as: :notifiable

  has_many :participations
  has_many :participants, through: :participations, source: :user
  has_many :posts

  validates :name, presence: true
  validates :description, presence: true
  validates :rules, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_after_start_date

  scope :active, -> { where('start_date <= ? AND end_date >= ?', Date.today, Date.today) }
  scope :upcoming, -> { where('start_date > ?', Date.today) }
  scope :past, -> { where('end_date < ?', Date.today) }
  scope :current, -> { where('end_date >= ?', Date.today) }

  def active?
    start_date <= Date.today && end_date >= Date.today
  end

  def starting_soon?
    start_date > Date.today
  end

  def days_left
    if active?
      (end_date - Date.today).to_i
    else
      0
    end
  end

  def days_to_start
    if starting_soon?
      (start_date - Date.today).to_i
    else
      0
    end
  end

  def signup_user(user)
    challenge_participations.create(user: user)

    Notification.create_notification(
      recipient: user,
      actor: nil,
      notifiable: self,
      category: :system,
      message: "You've signed up for #{name}!"
    )
  end

  private

  def end_date_after_start_date
    if start_date && end_date && end_date <= start_date
      errors.add(:end_date, "must be after the start date")
    end
  end
end