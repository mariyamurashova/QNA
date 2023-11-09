require 'rails_helper'

feature 'Author can delete his answer', %q{
In order to delete the answer 
As an answer's author
I'd like to be able to delete my answer
} do

  given(:user) { create(:user) }
  given(:author) { create (:user)}
  given(:question) { create(:question, author: user) }
  given!(:answers) { create_list(:answer, 3, question: question, author: author) }

  scenario "The answers's author tries to delete it", js: true do
    sign_in(author)
    visit question_path(question)
    page.find(:css,"a#delete_answer_#{ answers[0].id }").click
    page.driver.browser.switch_to.alert.accept

    expect(page).to have_content 'Your answer was successfully deleted'
  end

  scenario "Others try to delete the answer", js: true do
    sign_in(user)
    visit question_path(question)

    expect(page).to_not have_link "Delete Answer"
  end
end
