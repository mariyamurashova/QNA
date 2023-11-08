require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to coorect mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do
  
  given(:author) { create (:user) }
  given!(:question) { create (:question), author: author }
  given!(:answer) { create (:answer), author: author, question: question }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

   describe 'Authenticated user' do
    scenario 'edits his answer', js: true do
      sign_in author
      visit question_path(question)

      click_on 'Edit'


      within '.answers' do
        fill_in answer[body], with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors'
    scenario "tries to edit other user's question"
  end
end
