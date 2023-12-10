require 'rails_helper'

RSpec.describe User, type: :model do
 it { should validate_presence_of :email }
 it { should validate_presence_of :password }
 it { should have_many(:answers).with_foreign_key('author_id') }
 it { should have_many(:questions).with_foreign_key('author_id') }
end
