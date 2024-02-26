require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, author:author) }
  let(:answer) { create(:answer, question: question, author: author) }

  describe 'POST #vote' do 
    context "User votes for question" do
      let(:params) { { question_id: question, vottable: "question", vottable_id: question.id, value: 1, :format => :json } }
      let(:resource) { question }

      it_behaves_like 'available to vote' 

    context "Author tries to vote for his question" do
      it_behaves_like 'NOT available to vote' 
    end 
    end

    context "User votes for answer" do
      let(:params) { { answer_id: answer, vottable: "answer", vottable_id: answer.id, value: 1, :format => :json } }
      let(:resource) { answer }
    
      it_behaves_like 'available to vote'

    context "Author tries to vote for his answer" do 
      it_behaves_like 'NOT available to vote'
    end
    end
  end

  describe 'DELETE #destroy' do 
    context "User can delete his vote for" do
      let!(:vote) { create(:vote, vottable: question, user: user ) }
      let!(:vote_answer) { create(:vote, vottable: answer, user: user ) }

      context 'question' do
        it_behaves_like 'can delete the vote' do
          let(:params) { { id: question.id, vottable: "question", vottable_id: question.id } }
        end
      end

      context 'answer' do
        it_behaves_like 'can delete the vote' do
          let(:params) { { id: answer.id, vottable: "answer", vottable_id: answer.id, :format => :json  } }
        end
      end
    end

    context "User cannot delete other's vote from " do
      let!(:vote) { create(:vote, vottable: question, user: user ) }
      let!(:vote_answer) { create(:vote, vottable: answer, user: user ) }
      let(:new_user) { create(:user) }
      
      context 'question' do
        it_behaves_like 'can not delete the vote' do
          let(:params) { { id: question.id, vottable: "question", vottable_id: question.id } }
        end
      end
 
      context 'answer' do
       it_behaves_like 'can not delete the vote' do
          let(:params) { { id: answer.id, vottable: "answer", vottable_id: answer.id, :format => :json  } }
       end
      end
    end
  end
end


