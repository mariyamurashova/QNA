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

  describe "Question's author"  do

    background do
      sign_in question_author
      visit question_path(question)
    end

    scenario "can choose the best answer", js: true do
    
      page.find(:css, "a#best_answer_#{ answers[0].id }").click
      page.find(:css,"#check_best_answer_#{ answers[0].id }").set(true)
      page.find_button("confirm_#{ answers[0].id }").click

      expect(page).to have_css(".best")
    end

    scenario 'There can only be one best answer', js: true do
    
      page.find(:css, "a#best_answer_#{ answers[0].id }").click
      page.find(:css,"#check_best_answer_#{ answers[0].id }").set(true)
      page.find_button("confirm_#{ answers[0].id }").click

      page.find(:css, "a#best_answer_#{ answers[1].id }").click
      page.find(:css,"#check_best_answer_#{ answers[1].id }").set(true)
      page.find_button("confirm_#{ answers[1].id }").click

      best_answer = page.find(:css, ".best")

      expect(best_answer).to have_content(answers[1].body)
      expect(best_answer).to_not have_content(answers[0].body)
    end

    scenario 'The best answer should be first on the page', js: true do

      page.find(:css, "a#best_answer_#{ answers[1].id }").click
      page.find(:css,"#check_best_answer_#{ answers[1].id }").set(true)
      page.find_button("confirm_#{ answers[1].id }").click
      sleep(5)
      within ".answers" do
        first_answer_on_page = page.all(:css, ".answer_list").first
        expect(first_answer_on_page).to have_content(answers[1].body)
      end
    end
  end
end
