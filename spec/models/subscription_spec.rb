require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }

  describe "uniqueness of subscriptions" do
    let(:user){ create(:user) }
    let!(:question){ create(:question) }
    let!(:other_question){ create(:question) }
    let!(:subscription) { create(:subscription, user: user, question: question) }
 
    it "should not create new subscription" do
      expect{ user.subscriptions.create(question: question) }.to change{ Subscription.count }.by(0)
    end

    it "should create new subscription" do
      expect{ user.subscriptions.create(question: other_question) }.to change{ Subscription.count }.by(1)
    end
  end
end
