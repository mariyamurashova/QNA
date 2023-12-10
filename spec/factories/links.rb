FactoryBot.define do
factory :link do
    name { "MyGistFactory" }
    url { 'https://gist.github.com/mariyamurashova/afd25fa0988abb040110e50ed6b18014' }
  transient do
    linkable { nil }
  end

  linkable_id { linkable.id }
  linkable_type { linkable.class.name }
end
end
