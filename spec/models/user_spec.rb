require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:answers).with_foreign_key('author_id') }
  it { should have_many(:questions).with_foreign_key('author_id') }
  it { should have_many(:awords) }
  it { should have_many(:votes) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  describe 'User' do
    let(:user) { create(:user) }

  describe '.find_for_path' do
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('FindForOauthService')}

    it 'calls FindForOauthService' do
      expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end  
  end

  describe '.find_user' do
    context 'user exists' do
      
      it 'returns user' do
        expect(User.find_user(user.email)).to eq(user)
      end
    end

    context 'user does not exist' do
      it 'returns nil' do
        expect(User.find_user('new_user@mail')).to be(nil)
      end
    end
  end

  describe '.create_user' do
    it 'creates user' do
      User.create_user('newuser@mail').should be_an_instance_of(User)
    end
   end

  describe '.author?' do
    let!(:current_user) { create(:user) }

    context 'author of resource' do
      let(:resource) { create(:question, author: current_user) }

      it 'returns true' do
        expect(current_user).to be_author(resource)
      end
    end

    context 'not author' do
      let(:resource) { create(:question, author: user) }

      it 'returns false' do
        expect(current_user).to_not be_author(resource)
      end
    end
  end
end
end
