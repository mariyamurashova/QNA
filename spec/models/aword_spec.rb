require 'rails_helper'

RSpec.describe Aword, type: :model do
  it { should belong_to :question }
  it { should belong_to(:user).optional }

  it { should validate_presence_of :title }

  it 'have one attached file' do
    expect(Aword.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
