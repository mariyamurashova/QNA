require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => 'application/json' } }
 

describe 'GET /api/v1/questions/id/answers' do
  let(:method) { :get }
  let!(:question) {create(:question)}
  let!(:answers) { create_list(:answer, 2, question: question) }
  let(:answer) { answers.first }
  let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

  it_behaves_like 'API Authorizable'

  context 'authorized' do
    let(:access_token) { create(:access_token) } 
    let(:answer_response) { json['answers'].first }

    before { get api_path,  params: { access_token: access_token.token }, headers: headers }

    it 'returns 200 status' do
      expect(response).to be_successful
    end

    it 'returns list of answers' do
      expect(json['answers'].size).to eq 2
    end

    it 'returns public fields' do
      %w[id body created_at updated_at].each do |attr|
         expect(answer_response[attr]).to eq answer.send(attr).as_json
      end
    end

  end
describe 'GET /api/v1/questions/id/answers/id' do

  let(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }
  it_behaves_like 'API Authorizable'

  context 'authorized' do
    let(:access_token) { create(:access_token) }
    let(:comment) { create(:comment, answer: answer) }
    let(:link) { create(:link, answer: answer) }
    let(:answer_response) { json['answers'].first }

    before do
      answer.files.attach(io: File.open(Rails.root.join('spec', 'fixtures', '1.txt')), filename: '1.txt', content_type: 'text/txt')
      get api_path,  params: { access_token: access_token.token }, headers: headers
    end

    it 'returns 200 status' do
      expect(response).to be_successful
    end

    it 'returns 1 answer' do
      expect(json['answers'].size).to eq 1
    end

    it 'returns all fields' do
      %w[id body comments links ].each do |attr|
         expect(answer_response[attr]).to eq answer.send(attr).as_json
      end
    end

    it "returns answr's attached file's url" do
      file_url = Rails.application.routes.url_helpers.rails_blob_url(answer.files.first.blob, only_path: true) 
      expect( answer_response['files'].first).to eq(file_url)
    end
  end
end

describe 'POST /api/v1/questions/id/answers' do

  it_behaves_like 'API Authorizable'

  context 'authorized' do
    let!(:question) {create(:question)}
    let(:method) { :post }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:access_token) { create(:access_token) }
    let(:answers_amount) { question.answers.count } 
    
    context 'request with valid attributes' do
      before { post api_path,  params: { body: "Answer_body", access_token: access_token.token }, headers: nil }
        
      it 'returns 201 status' do
        expect(response).to be_successful
      end

      it 'adds new answer' do
        %w[id body created_at updated_at].each do |attr|
          expect(json['answer'][attr]).to eq question.answers.last.send(attr).as_json
        end
      end
    end

    context 'request with invalid attributes' do
      before { post api_path,  params: { access_token: access_token.token }, headers: nil }

      it 'returns 204 status' do
        expect(response.status).to eq(204)
      end

      it 'does not add new answer' do
        expect(question.answers.count).to eq(answers_amount)
      end
    end
  end
end

describe 'PATCH/api/v1/questions/id/answers/id' do

  it_behaves_like 'API Authorizable'

  let!(:question) {create(:question)}
  let(:author) {create(:user)}
  let(:user) { create(:user) }
  let!(:answer) { create(:answer, body: "Answer_body", question:question, author: author) }
  let(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }
  let(:access_token) { create(:access_token, resource_owner_id: author.id) }
  let(:access_token_user) { create(:access_token, resource_owner_id: user.id) }
    
  context 'author update his answer' do
  
    context 'request with valid attributes' do
      before { patch api_path,  params: { body: "new_body", access_token: access_token.token },headers: nil }
        
      it 'returns 201 status' do
        expect(response).to be_successful
      end

      it 'updates answer' do
        answer.reload
        expect(answer.body).to eq "new_body"
      end
    end
  end

  context 'not author tries to update the answer' do

    before { patch api_path,  params: { body: "new_body", access_token: access_token_user.token },headers: nil }

    it 'returns 403 status' do
      expect(response).to_not be_successful
    end

    it 'does not update answer' do
      answer.reload
      expect(answer.body).to eq("Answer_body") 
    end
    end
  end
end

  describe 'DELETE/api/v1/questions/id/answers/id' do
    let(:author) {create(:user)}
    let(:user) { create(:user) }
    let(:question) { create(:question)}
    let!(:answer) { create(:answer, question: question, author: author) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }
    let(:access_token) { create(:access_token, resource_owner_id: author.id) }
    let(:access_token_user) { create(:access_token, resource_owner_id: user.id) }
   
    context 'author deletes his question' do
      before { delete api_path,  params: { access_token: access_token.token },headers: nil }

      it 'returns 201 status' do
        expect(response).to be_successful
      end

      it 'deletes answer' do
        expect(question.answers.count).to eq(0)
      end
    end

    context 'not author tries to delete the answer' do

      before { delete api_path,  params: { access_token: access_token_user.token }, headers: nil }

      it 'returns 403 status' do
        expect(response).to_not be_successful
      end

      it 'does not delete answer' do
        expect(question.answers.count).to eq(1)
      end
    end 
  end
end 
