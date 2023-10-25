require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'GET #new' do
    before { login(user) }
    before { get :new, params: {:question_id => question} }
     
    it 'assigns a new Answer to @answer' do 
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new 
    end 
  end

  describe 'POST #create' do 
    before { login(user) }
    context 'with valid attributes' do 
      it 'saves a new answer in the datebase' do 
        expect { post :create, params: { :question_id => question, answer: attributes_for(:answer) } }.to change(Answer, :count).by(1)
      end

      it 'redirects to question show view' do 
        post :create, params: { :question_id => question, answer: attributes_for(:answer) }
         expect(response).to redirect_to question_path(assigns(:question))
      end
    end  

    context 'with invalid attributes' do 
      it 'does not save the answer' do
       expect { post :create, params: { :question_id => question, answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
      end

      it 'redirects to question show view' do  
        post :create, params: { :question_id => question, answer: attributes_for(:answer, :invalid) } 
        expect(response).to redirect_to question_path(assigns(:question))   
      end 
    end
    end
end
