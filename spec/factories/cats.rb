FactoryBot.define do
  factory :cat do
    name { Faker::Creature::Cat.name }
    age_id { Faker::Number.between(from: 2, to: 46) }
    breed_id { Faker::Number.between(from: 2, to: 51) }
    association :user
  end
end
