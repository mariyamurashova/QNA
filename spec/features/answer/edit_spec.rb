require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to coorect mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do
  
  given(:author) { create (:user) }
  given(:user) { create (:user) }
  given!(:question) { create (:question), author: author }
  given!(:answer) { create (:answer), author: author, question: question }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question) 
    expect(page).to_not have_link 'Edit'
  end
  
  scenario "user tries to edit other user's answer", js: true do
    sign_in user
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end    
  end

  describe 'Authenticated user' do

    background do
      sign_in author
      visit question_path(question) 
      click_on 'Edit'
    end 

    scenario 'edits his answer', js: true do

      within '.answers' do
        fill_in answer[body], with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors', js: true do
      
      within '.answers' do
        fill_in answer[body], with: ' '
        click_on 'Save'
        expect(page).to have_selector 'textarea'
      end

      within '.errors' do
        expect(page).to have_content "Body can't be blank"
      end
    end
  end
end