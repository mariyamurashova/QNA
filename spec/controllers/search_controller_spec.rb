require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  describe 'GET search' do 
    let!(:question) {create(:question, body: 'global searching' )}
    let!(:answer) {create(:answer, body: 'global searching' )}
    let(:results) { PgSearch.multisearch('global searching') }

    context 'there is searching content' do
       before { get :search, params: { query: 'global searching'}, format: :json }
       it_behaves_like 'has searching content'
    end

    context 'there is not searching content' do
      before { get :search, params: { query: 'not existing content'}, format: :json }
      it_behaves_like 'has not searching content'
    end
   end

  describe 'GET #scope_search' do 
    context 'search in Questions' do
      let!(:questions) {create_list(:question, 3, body: 'question_search' )}
      let(:results) {SearchService.new.searching("Question", 'question_search') }

      context 'there is searching content' do
        before { get :scope_search, params: { category: "Question", query: 'question_search'}, format: :json }
        it_behaves_like 'has searching content'
       end

      context 'there is not searching content' do
        before { get :scope_search, params: { category: "Question", query: 'not existing content'}, format: :json }
        it_behaves_like 'has not searching content'
      end
    end
  
    context 'search in Answers' do
      let!(:answers) {create_list(:answer, 3, body: 'answer_search' )}
      let(:results) { SearchService.new.searching("Answer", 'answer_search') }

      context 'there is searching content' do
        before { get :scope_search, params: { category: "Answer", query: 'answer_search'}, format: :json }
        it_behaves_like 'has searching content'
      end
  
      context 'there is not searching content' do
        before { get :scope_search, params: { category: "Answer", query: 'not existing content'}, format: :json }
        it_behaves_like 'has not searching content'
      end
    end

    context 'search in Comments' do
      let(:question) {create(:question)}
      let!(:comments) {create_list(:comment, 3, body: 'comment_search', commentable: question)}
      let(:results) { SearchService.new.searching("Comment", 'comment_search') }

      context 'there is searching content' do
        before { get :scope_search, params: { category: "Comment", query: 'comment_search'}, format: :json }
        it_behaves_like 'has searching content'
      end

      context 'there is not searching content' do
        before { get :scope_search, params: { category: "Comment", query: 'not existing content'}, format: :json }
        it_behaves_like 'has not searching content'
      end
    end

    context 'search in Users' do
      let(:user) {create(:user, email: "user@mail.com")}
      let(:answer) {create(:answer, author: user)} 
      let(:question) {create(:question, author: user)}
      let(:comment) {create(:comment, commentable: question)} 
    
      let(:results) { SearchService.new.searching("User", 'user@mail.com') }

      context 'there is searching content' do
        before { get :scope_search, params: { category: "User", query: 'user@mail.com'}, format: :json }
        it_behaves_like 'has searching content'
      end

      context 'there is not searching content' do
        before { get :scope_search, params: { category: "User", query: 'not existing content'}, format: :json }
        it_behaves_like 'has not searching content'
      end
    end
  end
end
