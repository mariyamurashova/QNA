require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question, author: author) }

  describe 'DELETE #destroy' do  

    context "answer's author delete the file" do
      before do
        login(author)
       answer.files.attach(io: File.open(Rails.root.join('spec', 'fixtures', '1.txt')), filename: '1.txt', content_type: 'text/txt')
      end

      it "deletes the file" do 
       expect { delete :destroy, params: {  id: answer  }, format: :js }.to change(ActiveStorage::Attachment, :count).by(-1)
      end
    end
  end
    
    context "tries to delete others answer" 

end
