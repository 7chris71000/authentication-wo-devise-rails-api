FactoryBot.define do 
  factory :item do
    name { Faker::Lorem.word }
    price_cents { Faker::Number.number(digits: 2) }
    description { Faker::Lorem.paragraph }
  end
end