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

  describe 'find_subscribers' do
    let!(:question){ create(:question) }
    let(:user){ create(:user) }
    let(:user2){ create(:user) }
    let!(:subscriptions) { [create(:subscription, user: user, question: question), create(:subscription, user: user2, question: question)] }
    
    it "should returns subscribers" do
      expect { self.receive(:where).with(question).and_return([user.id, user2.id]) }
    end
  end
end
