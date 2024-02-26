require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => 'application/json' } }
  let(:question) {create(:question)}
  let(:access_token) { create(:access_token) } 
  let(:author) {create(:user)}
  let(:user) { create(:user) }
  let!(:answers) { create_list(:answer, 2, question: question) }
  let(:answer) { answers.first }
  let(:answer_response) { json['answers'].first }
  let(:access_token_author) { create(:access_token, resource_owner_id: author.id) }
  let(:access_token_user) { create(:access_token, resource_owner_id: user.id) }
    
  describe 'GET /api/v1/questions/id/answers' do
    let(:method) { :get }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      before { get api_path,  params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'successful response'

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 2
      end

      it_behaves_like 'returns public fields' do
        let(:resource_response) { answer_response }
        let(:resource) { answer }
        let(:attributes) { %w[id body created_at updated_at] }
      end
    end
  end

  describe 'GET /api/v1/questions/id/answers/id' do
    let(:method) { :get }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:comment) { create(:comment, answer: answer) }
      let(:link) { create(:link, answer: answer) }

      before do
        answer.files.attach(io: File.open(Rails.root.join('spec', 'fixtures', '1.txt')), filename: '1.txt', content_type: 'text/txt')
        get api_path,  params: { access_token: access_token.token }, headers: headers
      end

      it_behaves_like 'successful response'

      it 'returns 1 answer' do
        expect(json['answers'].size).to eq 1
      end

      it_behaves_like 'returns public fields' do
        let(:resource_response) { answer_response }
        let(:resource) { answer }
        let(:attributes) { %w[id body created_at updated_at] }
      end

      it "returns answr's attached file's url" do
        file_url = Rails.application.routes.url_helpers.rails_blob_url(answer.files.first.blob, only_path: true) 
        expect( answer_response['files'].first).to eq(file_url)
      end
    end
  end

  describe 'POST /api/v1/questions/id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
  
    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
      let(:headers) { nil }
    end

    context 'authorized' do
      let(:answers_amount) { question.answers.count } 
    
      context 'request with valid attributes' do
        before { post api_path,  params: { body: "Answer_body", access_token: access_token.token }, headers: nil }
        
        it_behaves_like 'successful response' 
     
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
    let(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }
    let!(:answer) { create(:answer, body: "Answer_body", question:question, author: author) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
      let(:headers) { nil }
    end

    context 'author update his answer' do
      before { patch api_path,  params: { body: "new_body", access_token: access_token_author.token },headers: nil }
        
      it_behaves_like 'successful response' 
  
      it 'updates answer' do
        answer.reload
        expect(answer.body).to eq "new_body"
      end
    end

    context 'not author tries to update the answer' do
      before { patch api_path,  params: { body: "new_body", access_token: access_token_user.token },headers: nil }

      it_behaves_like 'NOT successful response'

      it 'does not update answer' do
        answer.reload
        expect(answer.body).to eq("Answer_body") 
      end
    end
  end

  describe 'DELETE/api/v1/questions/id/answers/id' do
    let(:question_new) {create(:question)}
    let!(:answer) { create(:answer, question: question_new, author: author) }
    let(:api_path) { "/api/v1/questions/#{question_new.id}/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
      let(:headers) { nil }
    end

    context 'author deletes his question' do
      before { delete api_path,  params: { access_token: access_token_author.token },headers: nil }

      it_behaves_like 'successful response' 

      it 'deletes answer' do
        expect(question_new.answers.count).to eq(0)
      end
    end

    context 'not author tries to delete the answer' do
      before { delete api_path,  params: { access_token: access_token_user.token }, headers: nil }

      it_behaves_like 'NOT successful response'

      it 'does not delete answer' do
        expect(question_new.answers.count).to eq(1)
      end
    end 
  end
end 
