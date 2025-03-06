class Avatar
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :image

  validates :image, presence: true
  validate :image_content_type

  private

  def image_content_type
    return unless image.present?

    unless image.content_type.in?(%w(image/jpeg image/png))
      errors.add(:image, 'must be a JPEG or PNG')
    end

    if image.size > 5.megabytes
      errors.add(:image, 'size exceeds the limit (5MB)')
    end
  end
end