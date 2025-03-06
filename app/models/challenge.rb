class Challenge < ApplicationRecord
  belongs_to :community
  belongs_to :creator, class_name: 'User'

  validates :title, presence: true
  validates :description, presence: true
end