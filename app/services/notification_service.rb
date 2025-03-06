class NotificationService
  def self.create(recipient:, actor:, action:, notifiable:)
    Notification.create(
      recipient: recipient,
      actor: actor,
      action: action,
      notifiable: notifiable,
    )

    broadcast_to_recipient(notification)
    notification
  end

  def self.broadcast_to_recipient(notification)
    NotificationsChannel.broadcast_to(
      notification.recipient,
      {
        id: notification.id,
        actor: notification.actor.name,
        action: notification.action,
        notifiable_type: notification.notifiable_type.underscore,
        notifiable_id: notification.notifiable_id,
        created_at: notification.created_at.strftime('%H:%M'),
      }
    )
  end
end