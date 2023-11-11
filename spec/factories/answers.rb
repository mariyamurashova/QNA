# frozen_string_literal: true

FactoryBot.define do
  sequence :body do |n|
    "MyAnswer#{n}"
  end

  factory :answer do
    body 
    best { false }
    question { association :question }
    author { association :user }

    trait :invalid do
      body { nil }
    end
  end
end
