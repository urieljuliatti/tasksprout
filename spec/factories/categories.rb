FactoryBot.define do
  factory :category do
    name { Faker::Movie.unique.title }
  end
end
