class Cat < ApplicationRecord
  belongs_to :user
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :age
  belongs_to :breed
  validates :age_id, numericality: { other_than: 1, message: "can't be blank" }
  validates :breed_id, numericality: { other_than: 1, message: "can't be blank" }
end
