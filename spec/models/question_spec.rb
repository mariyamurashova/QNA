# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to(:author).class_name('User') }
  it { should have_many :answers }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { is_expected.to have_many(:answers).dependent(:destroy) }
end
