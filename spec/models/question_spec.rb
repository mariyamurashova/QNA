# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like "vottable"
  it { should belong_to(:author).class_name('User') }
  it { should have_many(:answers).dependent(:destroy) } 
  it { should have_many(:links).dependent(:destroy) } 
  it { should have_one(:aword).dependent(:destroy) } 

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :aword }
  
  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
