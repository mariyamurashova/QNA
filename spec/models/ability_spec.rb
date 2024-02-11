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
    let(:question_other) { create :question, author: other }
    let(:answer) { create :answer, question: question, author: other }

     
    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, create(:question, author: user) }
    it { should_not be_able_to :update, create(:question, author: other)}

    it { should be_able_to :destroy, create(:question, author: user) }
    it { should_not be_able_to :destroy, create(:question, author: other) }


    it { should be_able_to :update, create(:answer, author: user)}
    it { should_not be_able_to :update, create(:answer, author: other) }

    context "question's author tries to set answer as best" do
      it { should be_able_to :set_best, create(:answer, question: question, author: other) }
    end

    context "answer's author tries to set answer as best" do
      it { should_not be_able_to :set_best, create(:answer, question: question_other, author: user) }
    end

    context "another user tries to set answer as best" do
      it { should_not be_able_to :set_best, create(:answer, question: question_other, author: other_1) } 
    end

    context "question's author cannot vote for his question" do
      it { should be_able_to :vote, question_other}
      it { should_not be_able_to :vote, question }
    end

    context "answer's author cannot vote for his question" do
      it { should be_able_to :vote, create(:answer, question: question, author: other) }
      it { should_not be_able_to :vote, create(:answer, question: question_other, author: user) }
    end

    context "user can revote for question/answer" do
      it { should be_able_to :destroy, create(:vote, vottable: question, user: user) }  
      it { should be_able_to :destroy, create(:vote, vottable: answer, user: user) }

      it { should_not be_able_to :destroy, create(:vote, vottable: question, user: other) }  
      it { should_not be_able_to :destroy, create(:vote, vottable: answer, user: other_1) } 
    end   
  end
end
