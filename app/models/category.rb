class Category < ApplicationRecord
  has_many :sports, dependent: :destroy

  validates :name, presence: true
end