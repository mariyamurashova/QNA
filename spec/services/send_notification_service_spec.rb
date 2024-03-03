require 'rails_helper'
RSpec.describe SendNotificationService do
  let(:author) {create(:user)}
  let(:question) {create(:question, author: author)}
  let(:answer) {create(:answer, question: question)}
  let!(:subscribers) {create_list(:user,3)}

  it 'sends notification about new answer to the question author' do
    expect(DailyDigestMailer).to receive(:mail_for_author).with(author, answer).and_call_original
    subject.notification_to_author(author, answer)
  end

  it 'sends notification about new answer to the question subscribers' do
    expect(DailyDigestMailer).to receive(:mail_for_subscribers).with(subscribers, answer).and_call_original
    subject.notification_to_subscribers(subscribers, answer)
  end
end
