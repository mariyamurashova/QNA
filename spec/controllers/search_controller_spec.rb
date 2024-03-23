require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  describe 'GET #multisearch' do 
    let!(:question) {create(:question, body: 'global searching' )}
    let!(:answer) {create(:answer, body: 'global searching' )}
    let(:results) { PgSearch.multisearch('global searching') }

    context 'there is searching content' do
       before { get :multisearch, params: { query: 'global searching'}, format: :json }
       it_behaves_like 'has searching content'
    end

    context 'there is not searching content' do
      before { get :multisearch, params: { query: 'not existing content'}, format: :json }
      it_behaves_like 'has not searching content'
    end
   end

  describe 'GET #question_search' do 
    let!(:questions) {create_list(:question, 3, body: 'question_search' )}
    let(:results) { Question.search_by_questions('question_search') }

    context 'there is searching content' do
      before { get :question_search, params: { query: 'question_search'}, format: :json }
      it_behaves_like 'has searching content'
    end

    context 'there is not searching content' do
      before { get :question_search, params: { query: 'not existing content'}, format: :json }
      it_behaves_like 'has not searching content'
    end
  end

  describe 'GET #answer_search' do 
    let!(:answers) {create_list(:answer, 3, body: 'answer_search' )}
    let(:results) { Answer.search_by_answers('answer_search') }

    context 'there is searching content' do
      before { get :answer_search, params: { query: 'answer_search'}, format: :json }
      it_behaves_like 'has searching content'
    end
  
    context 'there is not searching content' do
      before { get :answer_search, params: { query: 'not existing content'}, format: :json }
      it_behaves_like 'has not searching content'
    end
  end

   describe 'GET #comment_search' do 
    let(:question) {create(:question)}
    let!(:comments) {create_list(:comment, 3, body: 'comment_search', commentable: question)}
    let(:results) { Comment.search_by_comments('comment_search') }

    context 'there is searching content' do
      before { get :comment_search, params: { query: 'comment_search'}, format: :json }
       it_behaves_like 'has searching content'
    end

    context 'there is not searching content' do
      before { get :comment_search, params: { query: 'not existing content'}, format: :json }
      it_behaves_like 'has not searching content'
    end
  end

  describe 'GET #user_search' do
    let(:user) {create(:user, email: "user@mail.com")}
    let(:answer) {create(:answer, author: user)} 
    let(:question) {create(:question, author: user)}
    let(:comment) {create(:comment, commentable: question)} 
    
    let(:results) { User.search_by_users('user@mail.com') }

    context 'there is searching content' do
      before { get :user_search, params: { query: 'user@mail.com'}, format: :json }
       it_behaves_like 'has searching content'
    end

    context 'there is not searching content' do
      before { get :user_search, params: { query: 'not existing content'}, format: :json }
      it_behaves_like 'has not searching content'
    end
  end
end
