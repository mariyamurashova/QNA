require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author:user) }

  let(:answer) { create(:answer, question: question, author: user) }
  let(:commentable) { create(:answer, question: question, author: user) }

  describe 'POST #create' do 
   
    context "User adds comment to question/answer" do
       before { login(user) }

      it "saves a new comment to question to  the datebase" do 
        expect { post :create, params: { question_id: question, commentable: "question", commentable_id: question.id, comment: attributes_for(:comment), format: :js } }.to change(question.comments, :count).by(1)
      end

      it 'renders create template' do  
        post :create, params: { question_id: question, commentable: "question", commentable_id: question.id, comment: attributes_for(:comment), format: :js  } 
  
        expect(response).to render_template :create 
      end
       
      it "saves a new comment to answer to the datebase" do 
        expect { post :create, params: { answer_id: answer, commentable: "answer", commentable_id: answer.id, comment: attributes_for(:comment), format: :js } }.to change(answer.comments, :count).by(1)
      end

      it 'renders create template' do  
        post :create, params: { answer_id: answer, commentable: "answer", commentable_id: answer.id, comment: attributes_for(:comment), format: :js } 
  
        expect(response).to render_template :create 
      end
    end

    context "Unauthenticated user tries to add comment to question/answer" do

      it "doesn't save the comment to the question" do 
       expect { post :create, params: { question_id: question, commentable: "question", commentable_id: question.id, comment: attributes_for(:comment), format: :js } }.to change(question.comments, :count).by(0)
      end
      
      it 'redirects to sign in' do  
        post :create, params: { question_id: question, commentable: "question", commentable_id: question.id, comment: attributes_for(:comment), format: :js  } 
         expect(response).to have_http_status(:unauthorized)
      end

      it "doesn't save the comment to the answer" do 
        expect { post :create, params: { answer_id: answer, commentable: "answer", commentable_id: answer.id, comment: attributes_for(:comment), format: :js } }.to change(answer.comments, :count).by(0)
      end
      
      it 'redirects to sign in' do  
        post :create, params: { answer_id: answer, commentable: "answer", commentable_id: answer.id, comment: attributes_for(:comment), format: :js } 

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
