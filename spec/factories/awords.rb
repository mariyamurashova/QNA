FactoryBot.define do
factory :aword do
    title { "Best Aword" }
    image { Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/kolokol4848.png", 'kolokol4848/png') }
    question { association :question }
    user { association :user }
  end
end
