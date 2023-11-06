require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:author) { create(:user) }

  describe 'POST #create' do 

    context 'Authenticated user' do
    
      before { login(user) }

      context 'with valid attributes' do 
        it 'saves a new answer in the datebase' do 
          expect { post :create, params: { question_id: question, author: user, answer: attributes_for(:answer), format: :js } }.to change(question.answers, :count).by(1)
        end

        it 'redirects to question show view' do  
          post :create, params: { question_id: question, author_id: user, answer: attributes_for(:answer), format: :js } 
          expect(response).to render_template :create 
        end
      end
      
      context 'with invalid attributes' do 
        it 'does not save the answer' do
          expect { post :create, params: { question_id: question, author_id: author, answer: attributes_for(:answer, :invalid) }, format: :js  }.to_not change(Answer, :count)
        end

        it 'redirects to question show view' do  
          post :create, params: { question_id: question, author_id: user, answer: attributes_for(:answer, :invalid),  format: :js } 
        expect(response).to render_template :create 
        end 
      end
      end

    context 'Unauthenticated user' do

      it "doesn't save the answer" do 
        expect { post :create, params: { question_id: question, author: user, answer: attributes_for(:answer) } }.to_not change(question.answers, :count)
      end
      
      it 'redirects to sign in' do  
          post :create, params: { question_id: question, author_id: user, answer: attributes_for(:answer, :invalid) } 
        expect(response).to redirect_to  new_user_session_path  
      end
    end
  end



  describe 'DELETE #destroy' do 
    let!(:answer) { create(:answer, question: question, author:author) }

    context 'author delete his answer' do
      before { login(author) }
     
      it "deletes the answer" do 
       expect { delete :destroy, params: { id: answer, question_id: question, author_id: author } }.to change(Answer, :count).by(-1)
      end
    
    context "tries to delete others answer" do
      before { login(user) }

      it "it doesn't delete the answer" do 
       expect { delete :destroy, params: { id: answer, question_id: question, author_id: author } }.to change(Answer, :count).by(0)
      end
  
      it 'redirects to question show view ' do 
        delete :destroy, params: { id: answer, question_id: question, author_id: author  }
        expect(response).to redirect_to question_path(assigns(:answer).question) 
      end
    end
    end
  end
end
