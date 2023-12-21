FactoryBot.define do
  factory :vote do
    lile { 1 }
    dislike { 1 }
    association :user

  transient do
    vottable { nil }
  end

  vottable_id { vottable.id }
  vottable_type { vottable.class.name }
  end
end
