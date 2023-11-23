require 'rails_helper'

feature 'User can view the question and answers to it', %q{
  In order to find the answer to existing questions
  As a user
  I'd like to be able to view questions and answers to it
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author:user)}
  given!(:answers) {create_list(:answer, 3, question: question, author: user)}

  scenario 'view answers to question' do
    visit question_path(question)

    expect(page).to have_content(question.body)
    expect(page).to have_content(question.answers[0].body)
  end
end
