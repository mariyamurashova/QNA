require 'rails_helper'
RSpec.describe SendNotificationService do
  let(:author) {create(:user)}
  let(:question) {create(:question, author: author)}
  let(:answer) {create(:answer, question: question)}

  it 'sends notification about new answer to the question' do
    expect(DailyDigestMailer).to receive(:new_answer).with(author, answer).and_call_original
    subject.new_answer_notification(author, answer)
  end
end
