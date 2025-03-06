class Report < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :reason, presence: true
end
