class Notification < ApplicationRecord
  belongs_to :recipient, class_name: "User", foreign_key: :recipient_id
  belongs_to :actor, class_name: "User", foreign_key: :actor_id, optional: true
  belongs_to :notifiable, polymorphic: true, optional: true

  scope :unread, -> { where(read_at: nil) }
  scope :read, -> { where.not(read_at: nil) }

  scope :today, -> { where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day) }
  scope :yesterday, -> { where(created_at: 1.day.ago.beginning_of_day..1.day.ago.end_of_day) }
  scope :recent, -> { where(created_at: 2.days.ago..Time.zone.now) }

  enum :category, [ :system, :invitation, :activity, :social, :achievement ]

  def self.create_notification(params)
    recipient = params[:recipient]
    actor = params[:actor]
    notifiable = params[:notifiable]
    message = params[:message]
    category = params[:category]

    Notification.create(
      recipient: recipient,
      actor: actor,
      notifiable: notifiable,
      message: message,
      category: category
    )
  end

  def read?
    read_at.present?
  end

  def mark_as_read!
    update(read_at: Time.zone.now)
  end

  def time_ago
    seconds_ago = (Time.zone.now - created_at).to_i

    if seconds_ago < 60
      "just now"
    elsif seconds_ago < 3600
      "#{(seconds_ago / 60).to_i}m"
    elsif seconds_ago < 86400
      "#{(seconds_ago / 3600).to_i}h"
    elsif seconds_ago < 172800
      "yesterday"
    else
      created_at.strftime("%b %d")
    end
  end
end