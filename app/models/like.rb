class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post
  validates :user_id, uniqueness: { scope: :post_id, message: 'Post has already been taken' } # 同じ投稿に二重いいねを防ぐ
end
