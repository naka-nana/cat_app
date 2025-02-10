class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  validates :content, presence: true, length: { maximum: 50, message: 'コメントは50文字以内で入力してください。' }
end
