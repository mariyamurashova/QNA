# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    title { 'MyQuestion' }
    body { 'MyText' }
    author { association :user }

    trait :invalid do
      title { nil }
    end
  end
end
