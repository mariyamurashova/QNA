require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => 'application/json' } }

  describe 'GET /api/v1/profiles/me' do
    
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles/me' }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me',  params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'successful response'

      it_behaves_like 'returns public fields' do
        let(:resource_response) { json['user'] }
        let(:resource) { me }
        let(:attributes) { %w[id email admin created_at updated_at] }
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    let(:users) { create_list(:user, 3) }
    let(:access_token) { create(:access_token, resource_owner_id: users.first.id) }
    let(:user_response) { json['users'].last }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles' }
    end

    before { get '/api/v1/profiles/',  params: { access_token: access_token.token }, headers: headers }

    it_behaves_like 'successful response'

    it 'returns list of users except current_user' do
      expect(json['users'].size).to eq 2
      expect(json['users'].first['id']).to_not eq users.first.id
    end

    it_behaves_like 'returns public fields' do
      let(:resource_response) { user_response}
      let(:resource) { users.last }
      let(:attributes) { %w[id email admin created_at updated_at] }
    end
  end
end
