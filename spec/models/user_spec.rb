require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:answers).with_foreign_key('author_id') }
  it { should have_many(:questions).with_foreign_key('author_id') }
  it { should have_many(:awords) }
  it { should have_many(:votes) }
  it { should have_many(:authorizations).dependent(:destroy) }

  describe '.find_for_path' do
    let!(:user) { create(:user) }
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
      let!(:user) { create(:user) }
      
      it 'returns user' do
        User.find_user(user.email).should == user
      end
    end

    context 'user does not exist' do
      it 'returns nil' do
        User.find_user('new_user@mail').should == nil
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
      let!(:resource) { create(:question, author: current_user) }

      it 'returns true' do
        (current_user.id).should == (resource.author_id)
      end
    end

    context 'not author' do
      let(:user) {create(:user)}
      let!(:resource) { create(:question, author: user) }

      it 'returns false' do
        (current_user.id).should_not == (resource.author_id)
      end
    end
  end
end
