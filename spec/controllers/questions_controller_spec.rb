require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, author:user) }
  
  describe 'GET #index' do 
    let(:questions) { create_list(:question, 3, author: author) }

    before { get :index }

    it 'populates an array of all questions' do 
      get :index
      expect(assigns(:questions)).to match_array(questions) 
    end

    it 'renders index view' do 
      get :index
      expect(response).to render_template :index
    end 
  end

  describe 'GET #show' do
    before {  get :show, params: {id: question} }

    it 'assigns the requested question to @question' do  
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns new link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end  

  describe 'GET #new' do
    before { login(author) }
    before { get :new }

    it 'assigns a new Question to @question' do 
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns a new @link to @question.links' do 
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'assigns a new @aword to @question.aword' do 
      expect(assigns(:question).aword).to be_a_new(Aword)
    end

    it 'renders new view' do
      expect(response).to render_template :new 
    end 
  end

  describe 'GET #edit' do
    before { login(author) }
    before { get :edit, params: { id: question }, format: :js }

    it 'assigns the requested question to @question' do  
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
       get :edit, params: { id: question }, format: :json
       expect(response).to redirect_to root_path
    end  
  end

  describe 'POST #create' do 

    context 'Authenticated user' do
      before { login(author) }

      context 'with valid attributes' do 
        it 'saves a new question in the datebase' do 
          expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
        end

        it 'redirects to show view' do 
          post :create, params: { question: attributes_for(:question) }
          expect(response).to redirect_to assigns(:question)
        end
      end  

      context 'with invalid attributes' do 
        it 'does not save the question' do
          expect { post :create, params: { question: attributes_for(:question, title: nil) } }.to_not change(Question, :count)
        end

        it 're-renders new view' do  
          post :create, params: { question: attributes_for(:question, title: nil) } 
          expect(response).to render_template :new    
        end 
      end
      end
    end

    context 'Unauthenticated user'do
      it "doesn't save question" do 
        expect { post :create, params: { question: attributes_for(:question) } }.to_not change(Question, :count)
      end

      it 'redirects to sign in' do 
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to new_user_session_path 
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do 

      it 'assigns the requested question to @question' do 
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js 
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: {title: 'new title', body: 'new body'} }, format: :js 
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'renders update view' do 
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js 
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do 

      before { patch :update, params: { id: question, question: attributes_for(:question, title: nil) }, format: :js}
    
      it 'does not change question' do 
        question.reload
        expect(question.title).to eq 'MyQuestion'
        expect(question.body).to eq 'MyText'
      end

      it 'renders update view' do  
        expect(response).to render_template :update
      end
    end
  end 

  describe 'DELETE #destroy' do 
    let!(:question) { create(:question, author:author) }

    context 'author delete his question' do
      before { login(author) }

      it 'delete the question' do 
        expect { delete :destroy, params: { id: question } }.to change( Question, :count ).by(-1)
      end

      it 'redirects to index' do 
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end
  end
end  
