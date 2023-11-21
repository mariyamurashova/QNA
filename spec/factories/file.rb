FactoryBot.define do

  factory :file do
    association :answer
    association :question
  end
end
