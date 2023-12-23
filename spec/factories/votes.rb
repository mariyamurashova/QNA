FactoryBot.define do
  factory :vote do
    value { 1 }
    association :user

  transient do
    vottable { nil }
  end

  vottable_id { vottable.id }
  vottable_type { vottable.class.name }
  end
end
