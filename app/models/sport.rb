class Sport < ApplicationRecord
  belongs_to :category
  has_many :communities

  validates :name, presence: true

  has_one_attached :image
end
