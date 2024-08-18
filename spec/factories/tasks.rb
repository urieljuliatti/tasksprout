FactoryBot.define do
  factory :task do
    title { "MyString" }
    description { "MyText" }
    status { "MyString" }
    priority { "MyString" }
    due_date { "2024-08-18" }
    user
  end
end
