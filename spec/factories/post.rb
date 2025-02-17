FactoryBot.define do
  factory :post do
    title { 'テストタイトル' }
    content { 'テストコンテンツ' }
    association :user

    image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test_image.jpg'), 'image/jpeg') }
  end
end
