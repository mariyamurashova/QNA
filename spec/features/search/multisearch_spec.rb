require 'rails_helper'

feature 'User can search content', %q{
  "In order to quickly find the content 
  As user or guest
  I'd like to be able to use search feature" 
} do

  given(:user) { create(:user) }
  given!(:question) {create(:question, title: 'global searching',  body: 'global searching' )}
  given!(:answer) {create(:answer, body: 'global searching' )}

  scenario 'there is content user looking for', js: true do
    visit questions_path
#
     #page.find(:css, '.search-input-form').fill_in :with => 'global search'
    fill_in :query, with: 'global searching'
    click_on 'Search'

    expect(page).to have_content("Question: #{question.title} #{question.body}") 
    expect(page).to have_content("Answer: #{answer.body}") 
  end

  scenario 'there is no content user looking for', js: true do
    visit questions_path

    fill_in 'query', with: 'looking for smth'
    click_on 'Search'

    expect(page).to have_content("No results") 
  end
end
