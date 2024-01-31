require 'rails_helper'

RSpec.describe AuthorizationsController, type: :controller do
       
  describe 'GET #new' do
    before { get :new }

    it 'assigns a new Authorization to @authorization' do 
      expect(assigns(:authorization)).to be_a_new(Authorization)
    end
  end

  describe 'POST #create' do 
    let!(:user) { create(:user) }

    context 'user sends and confirms email' do
    
    context 'user already exists in DB' do
      it "saves a new user's authorization" do 
        expect(User.find_user(user.email)).to eq(user)
        expect{ User.create_user(user.email) }.to_not change(User, :count)
        expect{ user.create_authorization(provider: 'vkontakte',uid: '123456')}.to change(Authorization, :count).by(1)  
      end
    end  

    context 'user does not exist ' do
      it "saves user and his authorization"  do
        expect(User.find_user('new_user@mail')).to eq(nil)
        expect { User.create_user('new_user@mail') }.to change(User, :count).by(1) 
        expect{ user.create_authorization(provider: 'vkontakte',uid: '123456')}.to change(Authorization, :count).by(1)   
      end
    end 

     it 'login user' do 
        post :create, params: { authorization: { user_id: user, uid: 321, provider: 'vkontakte', email: 'new_user@mail' }}
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'user does not send email' do
      it 'does not login user' do 
        post :create, params: { authorization: { user_id: user, uid: 321, provider: 'vkontakte', email: '' }}
        expect(response).to redirect_to new_authorization_path(provider: 'vkontakte', uid: 321)
      end
    end
  end
end
