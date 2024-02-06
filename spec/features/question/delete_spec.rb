require 'rails_helper'

feature 'Author can delete his question', %q{
In order to delete the question 
As a question's author
I'd like to be able to delete my question
} do

  given(:user) { create(:user) }
  given(:author) { create (:user)}
  given(:question) { create(:question, author: author) }

  scenario "The question's author tries to delete it" do
    sign_in(author)
    visit question_path(question)
    click_on 'Delete Question'

    expect(page). to have_content 'Your question was successfully deleted'
  end

  scenario "Others try to delete question" do
    sign_in(user)
    visit question_path(question)
   
    expect(page).to_not have_link 'Delete Question'
  end
end
