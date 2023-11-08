require 'rails_helper'

feature 'User can edit his question', %q{
  In order to coorect mistakes
  As an author of question
  I'd like to be able to edit my question
} do
  
  given(:author) { create (:user) }
  given(:user) { create (:user) }
  given!(:question) { create (:question), author: author }

  scenario 'Unauthenticated user can not edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  scenario "user tries to edit other user's question", js: true do
    sign_in user
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'EditQuestion'
    end
      
  end

  describe 'Author' do

    background do
      sign_in author
      visit question_path(question) 
      click_on 'EditQuestion'
    end

    scenario 'edits his question', js: true do
   
      within '.question' do
        fill_in "Title", with: 'edited question title'
        fill_in "Body", with: 'edited question body'
        click_on 'Save'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.title
        expect(page).to have_content 'edited question title'
        expect(page).to have_content 'edited question body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his question with errors', js: true do

      within '.question' do
        fill_in "Title", with: ' '
        fill_in "Body", with: ' '
        click_on 'Save'
        expect(page).to have_selector 'textarea'
      end

      within '.errors' do
        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
      end
    end
  end
end
