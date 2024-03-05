class User < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
 
  
  VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i
  validates :password, format: { with: VALID_PASSWORD_REGEX, message: 'is invalid. Include both letters and numbers' }
  validates :nickname, presence: true
  validates :last_name, presence: true, format: { with: /\A[ぁ-んァ-ヶ一-龥々ー]+\z/, message: 'is invalid' }
  validates :first_name, presence: true, format: { with: /\A[ぁ-んァ-ヶ一-龥々ー]+\z/, message: 'is invalid' }
  validates :last_name_kana, presence: true, format: { with: /\A[\p{katakana}ー－]+\z/, message: 'is must be Katakana' }
  validates :first_name_kana, presence: true, format: { with: /\A[\p{katakana}ー－]+\z/, message: 'is must be Katakana' }
  validates :birth_date, presence: true
  validates :prefecture_id, numericality: { other_than: 1 }
end
