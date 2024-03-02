# frozen_string_literal: true

require 'rails_helper'
require Rails.root.join("spec/models/concerns/vottable_spec.rb")
require Rails.root.join("spec/models/concerns/commentable_spec.rb")

RSpec.describe Question, type: :model do
  it_behaves_like "vottable"
  it_behaves_like "commentable"
  it { should belong_to(:author).class_name('User') }
  it { should have_many(:answers).dependent(:destroy) } 
  it { should have_many(:links).dependent(:destroy) } 
  it { should have_one(:aword).dependent(:destroy) } 
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :aword }
  
  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'reputation' do
    let(:question) { build(:question) }

    it 'calls ReputationJob' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
   end
  end

  describe 'created_24_hours' do
    let!(:questions) { create_list(:question, 3) }

      it 'returns questions created_24_hours' do
        expect(Question.created_24_hours).to eq(questions)
      end
   end
end
