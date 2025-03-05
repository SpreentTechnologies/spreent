class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable, :lockable

  has_one_attached :avatar do |attachable|
    attachable.variant :circle, resize_to_limit: [300, 300]
  end

  has_many :posts
  has_many :comments
  has_many :likes

  attr_accessor :invitation_code

  validates :avatar, presence: true, on: :update
end
