require 'rails_helper'

feature 'User can add comments to answer', %q{
  In order to clarify the information about the answer
  As an authenticated
  I'd like to be able to add comments to the answer
} do
  
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, author:author) }
  given!(:answer) { create(:answer, question: question, author: author) }

  scenario 'Authenticated User adds comment to the answer', js: true do
    sign_in(user)
    visit question_path(question)
    click_link 'Add Comment'

    fill_in 'Comment', with: 'My comment'
    click_on 'Add Comment'

    expect(page).to have_content('My comment')
  end

  scenario "All users with open question's page can see new comment to question's answer"

  scenario "Unauthentecated user doesn't add comment to the answer" do
    visit question_path(question)
    expect(page).to_not have_link('Add Comment')
  end
end

