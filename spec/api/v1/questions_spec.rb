require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => 'application/json' } }

describe 'GET /api/v1/questions' do
  let(:method) { :get }
  let(:api_path) { '/api/v1/questions' }

  it_behaves_like 'API Authorizable'

  context 'authorized' do
    let(:access_token) { create(:access_token) }
    let!(:questions) { create_list(:question, 2) }
    let(:question) { questions.first }
    let(:question_response) { json['questions'].first }
    let!(:answers) { create_list(:answer,3, question: question) }

    before { get api_path,  params: { access_token: access_token.token }, headers: headers }

    it_behaves_like 'successful response'

    it 'returns list of questions' do
      expect(json['questions'].size).to eq 2
    end

    it_behaves_like 'returns public fields' do
      let(:resource_response) { question_response }
      let(:resource) { question } 
      let(:attributes) { %w[id title body created_at updated_at] }
    end

    it 'contains user object' do
      expect(question_response['author']['id']).to eq question.author.id
    end

    it 'contains short title' do
      expect(question_response['short_title']).to eq question.title.truncate(7) 
    end

    describe 'answers' do
      it 'returns list of answers' do
        expect(question_response['answers'].size).to eq 3
      end

      it_behaves_like 'returns public fields' do
        let(:resource_response) {question_response['answers'].first }
        let(:resource) {answers.first}
         let(:attributes) { %w[id body created_at updated_at] }
      end

    end
end

  describe 'GET /api/v1/questions/id' do
    let(:method) { :get }
    let!(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:resource_response) { json['question'] }
    let(:resource) { question }
    let(:attributes) { %w[id title body created_at updated_at] }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      before { get api_path,  params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'successful response'

      it_behaves_like 'response to show method' 

      it_behaves_like 'returns public fields'
    end

  describe 'POST /api/v1/questions' do
    let(:api_path) { "/api/v1/questions" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
      let(:headers) { nil }
    end

     context 'authorized' do  
      let(:access_token) { create(:access_token) }
      let(:questions_amount) { Question.count } 
    
      context 'request with valid attributes' do
        before { post api_path,  params: { question: { title: "Question_title", body: "Question_body" }, access_token: access_token.token }, headers: nil }
        
        it_behaves_like 'successful response'
  
        it 'adds new question to db' do
          %w[id title body created_at updated_at].each do |attr|
            expect(json['question'][attr]).to eq Question.last.send(attr).as_json
          end
        end
      end

      context 'request with invalid attributes' do
        before { post api_path,  params: { question: { body: "Question_body"}, access_token: access_token.token }, headers: nil }

         it 'returns 204 status' do
          expect(response.status).to eq (422)
        end

        it_behaves_like 'returns errors'

        it 'does not add new question to db' do
          expect(Question.count).to eq(questions_amount)
        end
      end
    end
  end

  describe 'PATCH/api/v1/questions/id' do
    let(:api_path) { "/api/v1/questions/#{question.id}" }   
    let(:author) {create(:user)}
    let(:user) { create(:user) }
    let!(:question) { create(:question, author: author) }
    let(:access_token) { create(:access_token, resource_owner_id: author.id) }
    let(:access_token_user) { create(:access_token, resource_owner_id: user.id) }
    
    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
      let(:headers) { nil }
    end

    context 'author update his question' do
      before { patch api_path,  params: { question: { title: "new_title"}, access_token: access_token.token } ,headers: nil }
        
      it_behaves_like 'successful response'
       
      it 'updates question' do
        question.reload
        expect(question.title).to eq "new_title"
      end
    end

    context 'with invalid attributes' do
      #let(:question) { create(:question,  author: author) }
      before { patch api_path,  params: { question: { title: nil}, access_token: access_token.token } ,headers: nil }

      it_behaves_like 'returns errors'

      it 'does not update the question' do
        question.reload
        expect(question.title).to eq('MyQuestion')
      end
    end

    context 'not author tries to update the question' do
      before { patch api_path,  params: { question: { title: "new_title"}, access_token: access_token_user.token },headers: nil }

      it_behaves_like 'NOT successful response'

      it 'does not update question' do
        question.reload
        expect(question.title).to eq 'MyQuestion' 
      end
    end
  end

  describe 'DELETE/api/v1/questions/id' do
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:author) {create(:user)}
    let(:user) { create(:user) }
    let!(:question) { create(:question, author: author) }
    let(:access_token) { create(:access_token, resource_owner_id: author.id) }
    let(:access_token_user) { create(:access_token, resource_owner_id: user.id) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
      let(:headers) { nil }
    end

    context 'author update his question' do
      before { delete api_path,  params: { access_token: access_token.token },headers: nil }

      it_behaves_like 'successful response'

      it 'deletes question' do
        expect(Question.count).to eq(0)
      end
    end

    context 'not author tries to update the question' do

       before { delete api_path,  params: { access_token: access_token_user.token },headers: nil }

       it_behaves_like 'NOT successful response'

      it 'does not delete question' do
        expect(Question.count).to eq(1)
      end
    end 
  end
end
end
end
