require 'rails_helper'

RSpec.describe Vote, type: :model do

  it { should belong_to(:vottable) }
  it { should belong_to(:user) }

   describe 'validate_uniqness' do
    let!(:user) { create :user }
    let!(:author) { create :user }
    let!(:question) { create :question, author: author }

    it 'can votes just once' do
      vote = create :vote, user: user, vottable: question
      new_vote = build :vote, user: user, vottable: question

      new_vote.valid?

      expect(new_vote.errors[:user]).to include "you couldn't vote twice"
    end
  end
   
  describe 'author_of_resource' do
    let!(:user) { create :user }
    let!(:author) { create :user }
    let!(:question) { create :question, author: author }
    let!(:vote) {  build :vote, user: author, vottable: question }

    it "not_author" do
      vote.author_of_resource
      expect(vote.errors.full_messages).to include("User You couldn't vote for your question")
    end
  end

end
