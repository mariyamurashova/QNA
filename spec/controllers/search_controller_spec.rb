require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #multisearch' do 
    let!(:question) {create(:question, body: 'global searching' )}
    let!(:answer) {create(:answer, body: 'global searching' )}
    let(:results) { PgSearch.multisearch('global searching') }

    context 'there is searching content' do
      before { get :multisearch, params: { query: 'global searching'}, format: :json }

      it 'populates an array of all items with given parameters' do  
        expect(assigns(:result)).to match_array(results) 
      end

      it 'it returns status 200' do 
        expect(response).to have_http_status(:ok)
      end
    end

    context 'there is not searching content' do
      before { get :multisearch, params: { query: 'not existing content'}, format: :json }

      it 'returns empty collection' do  
        expect(assigns(:result)).to match_array([ ]) 
      end

      it 'it returns status 200' do 
        expect(response).to have_http_status(:ok)
      end
    end
   end

    describe 'GET #question_search' do 
    let!(:question) {create_list(:question, 3, body: 'question_search' )}
    let(:results) { Question.search_by_questions('question_search') }

    context 'there is searching content' do
      before { get :question_search, params: { query: 'question_search'}, format: :json }

      it 'populates an array of all items with given parameters' do  
        expect(assigns(:result)).to match_array(results) 
      end

      it 'it returns status 200' do 
        expect(response).to have_http_status(:ok)
      end
    end

    context 'there is not searching content' do
      before { get :question_search, params: { query: 'not existing content'}, format: :json }

      it 'returns empty collection' do  
        expect(assigns(:result)).to match_array([ ]) 
      end

      it 'it returns status 200' do 
        expect(response).to have_http_status(:ok)
      end
    end
   end
end
