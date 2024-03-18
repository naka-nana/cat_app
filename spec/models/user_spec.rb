require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user, password: 'abc123', password_confirmation: 'abc123')
  end

  describe 'ユーザー新規登録' do
    context '新規登録がうまくいくとき' do
      it '全ての値が正しく入力されていれば登録できる' do
        expect(@user).to be_valid
      end
    end
    context '新規登録できないとき' do
      it 'nicknameが空では登録できない' do
        user = FactoryBot.build(:user)
        user.nickname = ''
        user.valid?
        expect(user.errors.full_messages).to include("Nickname can't be blank")
      end

      it 'nicknameが7文字以上では登録できない' do
        @user.nickname = 'abcdefg'
        @user.valid?
        expect(@user.errors.full_messages).to include('Nickname is too long (maximum is 6 characters)')
      end
      
      it 'emailが空では登録できない' do
        user = FactoryBot.build(:user)
        user.email = ''
        user.valid?
        expect(user.errors.full_messages).to include("Email can't be blank")
      end 
      it 'パスワードが必須であること' do
        @user.password = ''
        @user.password_confirmation = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Password can't be blank")
      end

      it 'パスワードが6文字以上であること' do
        @user.password = '123ab'
        @user.password_confirmation = '123ab'
        @user.valid?
        expect(@user.errors.full_messages).to include("Password is too short (minimum is 6 characters)")
      end

      it 'パスワードが半角英数字混合であること' do
        @user.password = 'aaaaaa' # 英字のみの場合
        @user.valid?
        expect(@user.errors.full_messages).to include('Password is invalid. Include both letters and numbers')
      end
      
      it 'パスワードが半角英字のみでは登録できないこと' do
        @user.password = 'aaaaaa' # 英字のみの場合
        @user.valid?
        expect(@user.errors.full_messages).to include('Password is invalid. Include both letters and numbers')
      end
      
      it 'パスワードが数字のみでは登録できないこと' do
        @user.password = '123456' # 数字のみの場合
        @user.valid?
        expect(@user.errors.full_messages).to include('Password is invalid. Include both letters and numbers')
      end

      it 'パスワードとパスワード（確認）が一致すること' do
        @user.password = '123abc'
        @user.password_confirmation = '123abcd'
        @user.valid?
        expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
      end

      it 'nicknameが7文字以上では登録できない' do
        @user.nickname = 'aaaaaaa'
        @user.valid?
        expect(@user.errors.full_messages).to include('Nickname is too long (maximum is 6 characters)')
      end

      it '重複したemailが存在する場合は登録できない' do
        @user.save
        another_user = FactoryBot.build(:user)
        another_user.email = @user.email
        another_user.valid?
        expect(another_user.errors.full_messages).to include('Email has already been taken')
      end

      it 'emailは@を含まないと登録できない' do
        @user.email = 'testmail'
        @user.valid?
        expect(@user.errors.full_messages).to include('Email is invalid')
      end

      it 'passwordが5文字以下では登録できない' do
        @user.password = '00000'
        @user.password_confirmation = '00000'
        @user.valid?
        expect(@user.errors.full_messages).to include('Password is too short (minimum is 6 characters)')
      end

      it 'passwordが129文字以上では登録できない' do
        @user.password = Faker::Internet.password(min_length: 129, max_length: 150)
        @user.password_confirmation = @user.password
        @user.valid?
        expect(@user.errors.full_messages).to include("Password is too long (maximum is 128 characters)")
      end

      it 'お名前(全角)は、名字と名前がそれぞれ必須であること' do
        @user.last_name = ''
        @user.first_name = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Last name can't be blank", "First name can't be blank")
      end

      it 'お名前(全角)は、全角（漢字・ひらがな・カタカナ）での入力が必須であること' do
        @user.last_name = 'yamada'
        @user.first_name = 'taro'
        @user.valid?
        expect(@user.errors.full_messages).to include("Last name is invalid", "First name is invalid")
      end

      it 'お名前カナ(全角)は、名字と名前がそれぞれ必須であること' do
        @user.last_name_kana = ''
        @user.first_name_kana = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Last name kana can't be blank", "First name kana can't be blank")
      end

      it 'お名前カナ(全角)は、全角（カタカナ）での入力が必須であること' do
        @user.last_name_kana = 'やまだ'
        @user.first_name_kana = 'たろう'
        @user.valid?
        expect(@user.errors.full_messages).to include("Last name kana is invalid", "First name kana is invalid")
      end

      it '生年月日が必須であること' do
        @user.birth_date = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Birth date can't be blank")
      end
    end
  end
end
