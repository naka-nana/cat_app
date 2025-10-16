FactoryBot.define do
  factory :post do
    association :user
    title { 'タイトル' }
    content { '本文' }

    # 画像必須なら自動で添付
    after(:build) do |post|
      unless post.image.attached?
        post.image.attach(
          io: File.open(Rails.root.join('spec/fixtures/test_image.jpg')),
          filename: 'test_image.jpg',
          content_type: 'image/jpeg'
        )
      end
    end
  end
end
