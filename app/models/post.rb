class Post < ApplicationRecord
  belongs_to :user
  belongs_to :cat, optional: true
  has_one_attached :image
  has_many :post_cats, dependent: :destroy
  has_many :cats, through: :post_cats
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :comments, dependent: :destroy
  validates :title, presence: true, length: { maximum: 30 }
  validates :content, length: { maximum: 1080 }
  validates :image, presence: true
end
