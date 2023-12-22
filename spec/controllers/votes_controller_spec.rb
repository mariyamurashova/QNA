require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, author:author) }
  let(:answer) { create(:answer, question: question, author: author) }

  describe 'POST #create' do 
   
    context "User votes for question/answer" do
       before { login(user) }

      it "saves a new question's vote in the datebase" do 
        expect { post :create, params: { question_id: question, vottable: "question", vottable_id: question.id, value: 1, :format => :json } }.to change(question.votes, :count).by(1)
      end

      it 'returns success status' do  
        post :create, params: { question_id: question, vottable: "question", vottable_id: question.id, value: 1, :format => :json } 
  
        expect(response).to have_http_status(:success)
      end

        it "saves a new answer's vote in the datebase" do 
        expect { post :create, params: { answer_id: answer, vottable: "answer", vottable_id: answer.id, value: 1, :format => :json } }.to change(answer.votes, :count).by(1)
      end

      it 'returns success status' do  
        post :create, params: { answer_id: answer, vottable: "answer", vottable_id: answer.id, value: 1, :format => :json } 
  
        expect(response).to have_http_status(:success)
      end
    end

    context "Author tries to vote for his question/answer" do
      before { login(author) }

      it "doesn't save a new question's vote in the datebase" do 
        expect { post :create, params: { question_id: question, vottable: "question", vottable_id: question.id, value: 1, :format => :json } }.to change(question.votes, :count).by(0)
      end

      it 'returns unprocessable_entity status' do  
        post :create, params: { question_id: question, vottable: "question", vottable_id: question.id, value: 1, :format => :json } 
  
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "doesn't save a new answer's vote in the datebase" do 
        expect { post :create, params: { answer_id: answer, vottable: "answer", vottable_id: answer.id, value: 1, :format => :json } }.to change(answer.votes, :count).by(0)
      end

      it 'returns unprocessable_entity status' do  
        post :create, params: { answer_id: answer, vottable: "answer", vottable_id: answer.id, value: 1, :format => :json } 
  
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end


