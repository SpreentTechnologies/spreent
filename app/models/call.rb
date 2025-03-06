class Call < ApplicationRecord
  belongs_to :caller, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  validates :uuid, presence: true, uniqueness: true
  validates :status, presence: true

  before_validation :generate_uuid, on: :create

  # Modern Rails 8.0.1 enum syntax
  enum :status, {
    pending: "pending",
    active: "active",
    ended: "ended",
    missed: "missed"
  }

  private

  def generate_uuid
    self.uuid ||= SecureRandom.uuid
  end
end