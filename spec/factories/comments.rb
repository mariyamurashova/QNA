FactoryBot.define do
  factory :comment do
    body { "new comment" }
    association :user

  #transient do
   # commentable {answer }
  #end

  #commentable_id { commentable.id }
  #commentable_type { commentable.class.name }
  end
end
