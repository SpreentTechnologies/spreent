class ChallengeInvitation < ApplicationRecord
  belongs_to :challenge
  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  enum :status, [ :pending, :accepted, :declined ]

  validates :challenge_id, uniqueness: { scope: :recipient_id, message: "invitation already exists" }

  after_create :send_notification

  private

  def send_notification
    Rails.logger.info "Invitation sent to #{recipient.email} for challenge #{challenge.name}"
  end
end
