# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    title { "MyString" }
    description { "MyText" }
    status { "pending" }
    priority { "low" }
    due_date { "2024-08-18" }
    user
    transient do
      post { build(:comments) }
    end
  end
end
