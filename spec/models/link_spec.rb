require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }
  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it { should allow_value('http://foo.com', 'http://bar.com/baz').for(:url) }
  it { should_not allow_value('asdfjkl').for(:url) }
end
