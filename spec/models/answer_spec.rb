# frozen_string_literal: true

require 'rails_helper'
require Rails.root.join("spec/models/concerns/vottable_spec.rb")

RSpec.describe Answer, type: :model do
  it_behaves_like "vottable"
  it { should belong_to :question }
  it { should have_many(:links).dependent(:destroy) }

  it { should belong_to(:author).class_name('User') }
  it { should validate_presence_of(:body) }

  it { should accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
