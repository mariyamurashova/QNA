require 'rails_helper'

feature 'Author can choose the best answer', %q{
  "In order to highlight the best answer to the question
  As an question's author
  I'd like to be able to choose the best answer" 
} do

  given(:question_author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: question_author) }
  given!(:answers) { create_list(:answer, 3, question: question, author: user) }

  scenario "Not question's author tries to choose the best answer" do
    sign_in user
    visit question_path(question)

    expect(page).to_not have_link "Select Best Answer"
  end

  scenario "Question's author can choose the best answer", js: true do
    sign_in question_author
    visit question_path(question)

    page.find(:css, "a#best_answer_#{ answers[0].id }").click
    page.find(:css,"#check_best_answer_#{answers[0].id}").set(true)
    page.find_button("confirm_#{answers[0].id}").click
    
    expect(page).to have_selector("#best_answer-#{answers[0].id}")
  end

  scenario 'There can only be one better answer' 

  scenario 'The best answer should be first on the list'
end
