FactoryBot.define do
  factory :authorization do
    user  { association :user }
    provider {  }
    uid { "123456" }
  end
end
