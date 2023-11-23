require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, author: author) }
  let(:answer) { create(:answer, question: question, author: author) }

  describe 'DELETE #destroy' do  
    context "Answer's attached files" do
      before do
        answer.files.attach(io: File.open(Rails.root.join('spec', 'fixtures', '1.txt')), filename: '1.txt', content_type: 'text/txt')
        answer.files.attach(io: File.open(Rails.root.join('spec', 'rails_helper.rb')), filename: 'rails_helper.rb', content_type: 'ruby/rb')
      end

      context "answer's author delete the file" do
        before { login(author) }

        it "deletes the file" do 
          expect { delete :destroy, params: {  id: answer  }, format: :js }.to change(ActiveStorage::Attachment, :count).by(-1)
        end
      end
    
      context "tries to delete others answer" do
        before { login(user) }
        it "it doesn't delete the file" do 
          expect { delete :destroy, params: { id: answer }, format: :js }.to change(ActiveStorage::Attachment, :count).by(0)
        end
      end
    end

    context "Question's attached files" do
      before do
        question.files.attach(io: File.open(Rails.root.join('spec', 'fixtures', '1.txt')), filename: '1.txt', content_type: 'text/txt')
        question.files.attach(io: File.open(Rails.root.join('spec', 'rails_helper.rb')), filename: 'rails_helper.rb', content_type: 'ruby/rb')
      end

      context "answer's author delete the file" do
        before { login(author) }

        it "deletes the file" do 
          expect { delete :destroy, params: {  id: question  }, format: :js }.to change(ActiveStorage::Attachment, :count).by(-1)
        end
      end
    
      context "tries to delete others answer" do
        before { login(user) }

        it "it doesn't delete the file" do 
          expect { delete :destroy, params: { id: question }, format: :js }.to change(ActiveStorage::Attachment, :count).by(0)
        end
      end
    end
  end
end
