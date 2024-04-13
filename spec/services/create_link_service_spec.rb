require 'rails_helper'
RSpec.describe CreateLinkService do 
  
  describe 'Multisearch' do  
    let!(:question) {create(:question, body: 'global searching' )}
    let!(:answer) {create(:answer, body: 'global searching' )}
    let!(:comment) {create(:comment, commentable: answer, body: 'global searching' )}
    let(:search_results) { PgSearch.multisearch('global searching') }
    let!(:links) {["http://79.174.80.177/questions/#{question.id}", "http://79.174.80.177/questions/#{answer.question.id}", 
                  "http://79.174.80.177/questions/#{answer.question.id}"]}

    it 'makes links for multisearching results' do
      subject { CreateLinkService.new }
      expect(subject.make_link_multisearch(search_results)).to eq(links)
    end
  end

  describe 'Question_search_scope' do
    let!(:question_array) {create_list(:question, 3, body: 'scope search' )}
    let(:question_scope_search_results) { Question.search_by_questions('scope search') }
    let!(:questions_links) {["http://79.174.80.177/questions/#{question_array[0].id}", "http://79.174.80.177/questions/#{question_array[1].id}", 
                  "http://79.174.80.177/questions/#{question_array[2].id}"]}
  
    it 'makes links for question_scope_search results' do
      subject { CreateLinkService.new }
      expect(subject.make_link_scope_search("Question", question_scope_search_results)).to eq(questions_links)
    end
  end
end
