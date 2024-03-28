require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be ableto add links
} do

  given(:user) { create(:user)}
  given(:gist_url) {'https://gist.github.com/mariyamurashova/afd25fa0988abb040110e50ed6b18014'}
  given(:google_url) {'https://www.google.com'}

  scenario 'User adds link when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Add Link'

    page.all('.nested_fields').first.fill_in 'Link name', with:  'Google'
    page.all('.nested_fields').first.fill_in 'Url', with: google_url
    within '.ask_question' do
      click_on 'Ask'
    end
    within '.question' do
      expect(page).to have_css('.gist')
      expect(page).to have_link('Google'), href: google_url
    end
  end

  scenario 'User adds links with invalid format', js: true do
    sign_in(user)
    visit new_question_path
    
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: '://bar.com/baz'
    
    click_on 'Ask'

    within '.error' do
      expect(page).to have_content 'Links url is invalid'
    end
  end
end
