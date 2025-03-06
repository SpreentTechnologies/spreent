class Notification < ApplicationRecord
  belongs_to :recipient, polymorphic: true
  belongs_to :actor, polymorphic: true
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(read_at: nil) }
  scope :recent, -> { order(created_at: :desc).limit(5) }

  def read?
    read_at.present?
  end

  def mark_as_read!
    update(read_at: Time.zone.now)
  end
end