FactoryBot.define do
factory :link do
    name { "MyGistFactory" }
    url { 'https://gist.github.com/mariyamurashova' }
  transient do
    linkable { nil }
  end

  linkable_id { linkable.id }
  linkable_type { linkable.class.name }
end
end
