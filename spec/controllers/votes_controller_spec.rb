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

  describe 'DELETE #destroy' do 
  
    context "User can delete his vote for question/answer" do
      let!(:vote) { create(:vote, vottable: question, user: user ) }
      let!(:vote_answer) { create(:vote, vottable: answer, user: user ) }

      before { login(user) }

      it "deletes the vote from question" do 
        expect { delete :destroy, params: { id: question.id, vottable: "question", vottable_id: question.id }, format: :json }.to change(Vote, :count).by(-1)
      end

      it 'returns success status' do  
        delete :destroy, params: { id: question.id, vottable: "question", vottable_id: question.id, :format => :json  } 
  
        expect(response).to have_http_status(:success)
      end

      it "deletes the vote from answer" do 
        expect { delete :destroy, params: { id: answer.id, vottable: "answer", vottable_id: answer.id, :format => :json  }, format: :json }.to change(Vote, :count).by(-1)
      end

      it 'returns success status' do  
        delete :destroy, params: { id: answer.id, vottable: "question", vottable_id: question.id, :format => :json  } 
  
        expect(response).to have_http_status(:success)
      end
    end

    context "User cannot delete others vote from question/answer" do
      let!(:vote) { create(:vote, vottable: question, user: user ) }
      let!(:vote_answer) { create(:vote, vottable: answer, user: user ) }
      let(:new_user) { create(:user) }
      
      before { login(new_user) }
      it "doesn't delete the vote from question" do 
        expect { delete :destroy, params: { id: question.id, vottable: "question", vottable_id: question.id }, format: :json }.to change(Vote, :count).by(0)
      end

      it 'returns error status' do  
        delete :destroy, params: { id: question.id, vottable: "question", vottable_id: question.id, :format => :json  } 
  
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "doesn't delete the vote from answer" do 
        expect { delete :destroy, params: { id: answer.id, vottable: "answer", vottable_id: answer.id, :format => :json  }, format: :json }.to change(Vote, :count).by(0)
      end

      it 'returns error status' do  
        delete :destroy, params: { id: answer.id, vottable: "question", vottable_id: question.id, :format => :json  } 
  
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end


