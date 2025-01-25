class Cat < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :age
  belongs_to :breed
  validates :name, presence: true, length: { maximum: 40 }
  validates :age_id, numericality: { other_than: 1, message: "can't be blank" }
  validates :breed_id, numericality: { other_than: 1, message: "can't be blank" }
end
