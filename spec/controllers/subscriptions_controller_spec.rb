require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, author:user) }
  
  describe 'POST #create' do 

    context 'Authenticated user' do
      before { login(user) }

      it "creates a new user's subscription" do 
        expect { post :create, params: { question_id: question, user_id: user }, format: :js}.to change(user.subscriptions, :count).by(1)
      end

      it "renders question's show template" do 
        post :create, params: { question_id: question, user_id: user }, format: :js 
        expect(response).to render_template :create
      end
    end  
    
    context 'Unauthenticated user'do
      it "doesn't create a new user's subscription" do 
        expect { post :create, params: { question_id: question, user_id: user }, format: :ja }.to change(user.subscriptions, :count).by(0)
      end

      it "renders question's show template" do 
        post :create, params: { question_id: question, user_id: user }, format: :js
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'DELETE #destroy' do 
    let!(:subscription) { create(:subscription, user: user, question: question) }

    context 'user cancels his subscription' do
      before { login(user) }

      it 'deletes the subscription' do 
        expect { delete :destroy, params: {id: question.id, user_id: user.id },format: :js  }.to change(Subscription, :count ).by(-1)
      end
    end
  end
end
