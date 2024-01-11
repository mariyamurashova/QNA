require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author:user) }

  let(:answer) { create(:answer, question: question, author: user) }
  let(:commentable) { create(:answer, question: question, author: user) }

  describe 'POST #create' do 
   
    context "User adds comment to question/answer" do
       before { login(user) }
       
        it "saves a new comment to answer to the datebase" do 
        expect { post :create, params: { answer_id: answer, commentable: "answer", commentable_id: answer.id, comment: attributes_for(:comment), format: :js } }.to change(answer.comments, :count).by(1)
      end

      it 'returns success status' do  
        post :create, params: { answer_id: answer, commentable: "answer", commentable_id: answer.id, comment: attributes_for(:comment), format: :js } 
  
         expect(response).to render_template :create 
      end
    end
  end
end
