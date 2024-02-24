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
      #ActiveStorage::Current.url_options = { protocol: request.protocol, host: request.host, port: request.port }
      #answer_response['files'].each do |file|
      #byebug
        #expect( answer_response['files'].first).to eq answer.files.first.url.as_json
      #end
    end
  end
end

end 
end 
