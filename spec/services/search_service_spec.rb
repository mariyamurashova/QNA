require 'rails_helper'
RSpec.describe SearchService do 
  let!(:question) {create(:question, body: 'question searching' )}
  let!(:answer) {create(:answer, body: ' answer searching' )}
  let!(:comment) {create(:comment, commentable: answer, body: 'comment searching' )}
  let!(:user) {create(:user, email: 'user_test@mail.com') }
  let(:question_results) { Question.search_by_questions('question searching') }
  let(:answer_results) { Answer.search_by_answers('answer searching') }
  let(:comment_results) { Comment.search_by_comments('comment searching') }
  let(:user_results) { User.search_by_users('user_test@mail.com') }
   
  it 'finds questions according to a searching query' do
    subject { SearchService.new }
    expect(subject.searching("Question", 'question searching' )).to eq(question_results)
  end

  it 'finds answers according to a searching query' do
    subject { SearchService.new }
    expect(subject.searching("Answer", 'answer searching' )).to eq(answer_results)
  end

  it 'finds comments according to a searching query' do
    subject { SearchService.new }
    expect(subject.searching("Comment", 'comment searching' )).to eq(comment_results)
  end

   it 'finds user according to a searching query' do
    subject { SearchService.new }
    expect(subject.searching("User", 'user_test@mail.com' )).to eq(user_results)
  end
end
