require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  let(:author) {create(:user)}
  let(:question) {create(:question, author: author)}
  let(:answer) {create(:answer, question: question)}
  let(:users) { create_list(:user, 2) }
  let(:subscription) {create(:subscription, question: question, user: subscriber) }
  let(:subscribers) { answer.question.subscribers }

  it 'sends notification about new answer to the question subscribers' do
    subscribers.each do |user|
      expect(NewAnswerNotificationMailer).to receive(:new_answer_notification).with(answer,user).and_call_original
    end
     NewAnswerNotificationJob.perform_now(answer)
  end

  it 'does not sends notification about new answer to not subscribed users' do
    users.each do |user|
      expect(NewAnswerNotificationMailer).to_not receive(:new_answer_notification).with(answer,user).and_call_original
    end
     NewAnswerNotificationJob.perform_now(answer)
  end
end
