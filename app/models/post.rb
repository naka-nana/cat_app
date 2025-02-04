class Post < ApplicationRecord
  belongs_to :user
  belongs_to :cat, optional: true
  has_one_attached :image
  has_many :post_cats
  has_many :cats, through: :post_cats
  validates :title, presence: true, length: { maximum: 30 }
  validates :content, length: { maximum: 1080 }
  validates :image, presence: true
end
