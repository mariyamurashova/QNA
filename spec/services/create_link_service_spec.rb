require 'rails_helper'
RSpec.describe CreateLinkService do
  let!(:question) {create(:question, body: 'global searching' )}
  let!(:answer) {create(:answer, body: 'global searching' )}
  let!(:comment) {create(:comment, commentable: answer, body: 'global searching' )}
  let(:search_results) { PgSearch.multisearch('global searching') }
  let!(:links) {["http://localhost:3000/questions/#{question.id}", "http://localhost:3000/questions/#{answer.question.id}", 
                  "http://localhost:3000/questions/#{answer.question.id}"]}

  it 'makes links for searching results' do
    subject { CreateLinkService.new }
    expect(subject.make_link(search_results)).to eq(links)
    end
end
