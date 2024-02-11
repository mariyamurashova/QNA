require 'rails_helper'

RSpec.describe LinksController, type: :controller do 
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, author: author) }
  let(:answer) { create(:answer, question: question, author: author) }

  describe 'DELETE #destroy' do 

    context "Answer's links" do
      let!(:link) { create(:link, linkable: answer) }

      context "answer's author delete the link" do
        before { login(author) }

        it "deletes the link" do 
          expect { delete :destroy, params: { id: answer}, format: :js }.to change(Link, :count).by(-1)
        end
      end
    end

    context "Question's attached links" do
      let!(:link) { create(:link, linkable: question) }

      context "answer's author delete the link" do
        before { login(author) }

        it "deletes the file" do 
          expect { delete :destroy, params: {  id: question  }, format: :js }.to change(Link, :count).by(-1)
        end
      end
    end
  end     
end
