class Community < ActiveRecord::Base
  validates :name, presence: true
  validates :description, presence: true
  validates :rules, presence: true
end
