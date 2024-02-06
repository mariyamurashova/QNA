require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for quest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all}
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:other_1) { create :user}
    let(:question) { create :question, author: user }
  
    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, create(:question, author: user) }
    it { should_not be_able_to :update, create(:question, author: other), user: user }

    it { should be_able_to :destroy, create(:question, author: user) }
    it { should_not be_able_to :destroy, create(:question, author: other), user: user }


    it { should be_able_to :update, create(:answer, author: user), user: user }
    it { should_not be_able_to :update, create(:answer, author: other), user: user }


    it { should be_able_to :update, create(:comment, commentable: question, user: user) }
    it { should_not be_able_to :update, create(:comment, commentable: question, user: other), user: user }

    context "question's author tries to set answer as best" do
      it { should be_able_to :set_best, create(:answer, question: question, author: other), user: user }
    end

    context "answer's author tries to set answer as best" do
      subject(:ability) { Ability.new(other) }   
      it { should_not be_able_to :set_best, create(:answer, question: question, author: other), user: other }
    end

    context "another user tries to set answer as best" do
      subject(:ability) { Ability.new(other) } 
      it { should_not be_able_to :set_best, create(:answer, question: question, author: other), user: other_1 } 
    end

  end
end
