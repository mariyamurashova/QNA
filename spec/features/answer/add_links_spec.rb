require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be ableto add links
} do

  given(:user) { create(:user)}
  given(:question) { create(:question) }
  given(:gist_url) {'https://gist.github.com/mariyamurashova/afd25fa0988abb040110e50ed6b18014'}
  given(:google_url) {'https://www.google.com'}

   scenario 'User adds links when give an answer', js: true do
    sign_in(user)
    visit question_path(question)
    
    fill_in 'Your answer', with: 'My answer'

    fill_in 'Link name', with:  'My gist'
    fill_in 'Url', with: gist_url
    
    click_on 'Add Link'

    page.all('.nested_fields').first.fill_in 'Link name', with:  'Google'
    page.all('.nested_fields').first.fill_in 'Url', with: google_url
 
    click_on 'Add Answer'

    expect(page).to have_link('Google'), href: google_url
    expect(page).to have_css('.gist') 
  end

  scenario 'User adds links with invalid format', js: true do
    sign_in(user)
    visit question_path(question)
    
    fill_in 'Your answer', with: 'My answer'

    fill_in 'Link name', with:  'My gist'
    fill_in 'Url', with: '://bar.com/baz'
    
    click_on 'Add Answer'

    within '.errors' do
      expect(page).to have_content 'Links url is invalid'
    end
  end
end
