require 'rails_helper'

RSpec.describe AwordsController, type: :controller do
describe 'GET #index' do 
    let!(:user) { create(:user) }
    let!(:awords) { create_list(:aword, 3, user: user) }

    before { login(user) }

    it 'populates an array of all questions' do 
      get :index
      expect(assigns(:awords)).to match_array(user.awords) 
    end

    it 'renders index view' do 
      get :index
      expect(response).to render_template :index
    end 
  end
end
