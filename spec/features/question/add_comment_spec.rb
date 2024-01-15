require 'rails_helper'

feature 'User can add comments to questions', %q{
  In order to clarify the information about the question
  As an authenticated
  I'd like to be able to add comments to the question
} do
  
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, author:author) }
  given!(:answer) { create(:answer, question: question, author: author) }

  scenario 'Authenticated User adds comment to the question', js: true do
    sign_in(user)
    visit question_path(question)
    within '.question' do
      click_link 'Add Comment'

      fill_in 'Comment', with: 'My comment'
      click_on 'Add Comment'
    end
    within '.question_comments' do
      expect(page).to have_content('My comment')
    end
  end


  scenario 'Authenticated User tries to add empty comment to the question', js: true do
    sign_in(user)
    visit question_path(question)
    within '.question' do
      click_link 'Add Comment'
      fill_in 'Comment', with: ''
      click_on 'Add Comment'
    end
    within '.notice' do
      expect(page).to have_content("Body can't be blank")
    end
  end

  scenario "All users with open question's page can see new comment to the question", js: true do
    #Capybara.current_driver = :selenium
    Capybara.using_session('user') do
      sign_in(user)
      visit question_path(question)
    end
 
    Capybara.using_session('guest') do
      visit question_path(question)
    end

    Capybara.using_session('user') do
      within '.question' do
        click_link 'Add Comment'

        fill_in 'Comment', with: 'My comment'  
        click_on 'Add Comment'
      end
      within '.question_comments' do
        expect(page).to have_content('My comment')
      end
    end

    Capybara.using_session('guest') do
      within '.question_comments' do
        expect(page).to have_content('My comment')
      end
    end
  end

  scenario "Unauthentecated user doesn't add comment to the answer" do
    visit question_path(question)
    within '.question' do
      click_link 'Add Comment'

      expect(page).to have_current_path(new_user_session_path)
    end
  end
end

