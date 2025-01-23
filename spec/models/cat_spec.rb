require 'rails_helper'

RSpec.describe Cat, type: :model do
  before do
    @cat = FactoryBot.build(:cat)
  end
  describe 'ねこ新規登録' do
    context '新規登録できるとき' do
      it 'nameとage、breedが存在すれば登録できる' do
        expect(@cat).to be_valid
      end
    end
    context '新規登録できないとき' do
      it 'nameが空では登録できない' do
        @cat = FactoryBot.build(:cat)
        @cat.name = ''
        @cat.valid?
        expect(@cat.errors.full_messages).to include("Name can't be blank")
      end
      it 'ageが空では登録できない' do
        @cat = FactoryBot.build(:cat)
        @cat.age_id = ' '
        @cat.valid?
        expect(@cat.errors.full_messages).to include("Age can't be blank")
      end
      it 'breedが空では登録できない' do
        @cat = FactoryBot.build(:cat)
        @cat.breed_id = ' '
        @cat.valid?
        expect(@cat.errors.full_messages).to include("Breed can't be blank")
      end
      it 'nameが40文字以上では登録できない' do
        @cat = FactoryBot.build(:cat)
        @cat.name = 'a' * 41
        @cat.valid?
        expect(@cat.errors.full_messages).to include('Name is too long (maximum is 40 characters)')
      end
      it 'ageが選択されてないと登録できない' do
        @cat = FactoryBot.build(:cat)
        @cat.age_id = '1'
        @cat.valid?
        expect(@cat.errors.full_messages).to include("Age can't be blank")
      end
      it 'breedが選択されてないと登録できない' do
        @cat = FactoryBot.build(:cat)
        @cat.breed_id = '1'
        @cat.valid?
        expect(@cat.errors.full_messages).to include("Breed can't be blank")
      end
    end
  end
end
