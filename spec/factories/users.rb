FactoryBot.define do

 # factory :confirmed_user, :parent => :user do
  #after(:create) { |user| user.confirm }
 # end

  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password { '12345678' }
    password_confirmation { '12345678' }  
    confirmed_at { Time.zone.now }
  end
end
