require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author:user) }
  let(:answer) { create(:answer, question: question, author: user) }

  describe 'POST #create' do 
    before { login(user) }

    context "Question's votes" do

      it 'saves a new vote in the datebase' do 
        expect { post :create, params: { question_id: question, vottable: "question", vottable_id: question.id, author: user, value: 1, :format => :json } }.to change(question.votes, :count).by(1)
      end

      it 'renders create template' do  
        post :create, params: {question_id: question, vottable: "question", vottable_id: question.id, author: user, value: 1, :format => :json } 
  
        expect(response).to have_http_status(:success)
      end
    end

    context "Answer's votes" do

      it 'saves a new vote in the datebase' do 
        expect { post :create, params: { answer_id: answer, vottable: "answer", vottable_id: answer.id, author: user, value: 1, :format => :json } }.to change(answer.votes, :count).by(1)
      end

      it 'renders create template' do  
        post :create, params: { answer_id: answer, vottable: "answer", vottable_id: answer.id, author: user, value: 1, :format => :json } 
  
        expect(response).to have_http_status(:success)
      end
    end
  end
end


