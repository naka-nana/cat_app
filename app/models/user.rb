class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :cats, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :likes
  has_many :liked_posts, through: :likes, source: :post
  has_many :comments, dependent: :destroy
  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :following, through: :active_relationships, source: :following

  # フォローされる側の関係
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'following_id', dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  # ユーザーをフォローするメソッド
  def follow(user)
    active_relationships.find_or_create_by(following_id: user.id)
  end

  # ユーザーのフォローを解除するメソッド
  def unfollow(user)
    following.delete(user)
  end

  # すでにフォローしているか判定するメソッド
  def following?(user)
    following.include?(user)
  end
  validates :nickname, presence: true, length: { maximum: 6 }
  validates :password, presence: true,
                       format: { with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i, message: 'is invalid. Include both letters and numbers' }
end
