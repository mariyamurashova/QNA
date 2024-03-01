# frozen_string_literal: true

require 'rails_helper'
require Rails.root.join("spec/models/concerns/vottable_spec.rb")
require Rails.root.join("spec/models/concerns/commentable_spec.rb")

RSpec.describe Answer, type: :model do
  it_behaves_like "vottable"
  it_behaves_like "commentable"
  it { should belong_to :question }
  it { should have_many(:links).dependent(:destroy) }

  it { should belong_to(:author).class_name('User') }
  it { should validate_presence_of(:body) }

  it { should accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe "notifications to question's author " do
    let(:service) { SendNotificationService.new }
    let(:author) {create(:user)}
    let(:question) { create(:question, author: author) }
    let(:answer) { build(:answer, question: question)}


    before do
      allow(SendNotificationService).to receive(:new).and_return(service)
    end

    it 'calls send_notification' do
      expect(service).to receive(:new_answer_notification).with(author, answer)
      answer.save!
    end
  end
end
