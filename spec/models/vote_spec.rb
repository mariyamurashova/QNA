require 'rails_helper'

RSpec.describe Vote, type: :model do

  it { should belong_to(:vottable) }
  it { should belong_to(:user) }

  describe 'validate_uniqness' do
    let!(:user) { create :user }
    let!(:author) { create :user }

    context 'question' do
      it_behaves_like 'not unique vote' do
        let(:resource) { create :question, author: author }
      end
    end

    context 'answer' do
      it_behaves_like 'not unique vote' do
        let(:resource) { create :answer, author: author }
      end
    end
  end
   
  describe 'author_of_resource' do
    let!(:user) { create :user }
    let!(:author) { create :user }
  
    context 'question' do
      it_behaves_like 'author cannot vote' do
        let(:resource)  { create :question, author: author }
      end
    end


    context'answer' do
      it_behaves_like 'author cannot vote' do
        let(:resource)  { create :answer, author: author }
      end
    end
  end
end
