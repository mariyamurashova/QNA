require 'rails_helper'

feature 'User can search content', %q{
  "In order to quickly find the content 
  As user or guest
  I'd like to be able to use search features" 
} do

  describe 'Multisearch' do 
    given!(:question) {create(:question, title: 'global searching',  body: 'global searching' )}
    given!(:answer) {create(:answer, body: 'global searching' )}

    scenario 'there is content user looking for', js: true do
      visit questions_path
      within '.multisearch' do
        fill_in :query, with: 'global searching'
        click_on 'Search'
      end
    
      expect(page).to have_content("Question #{question.title} #{question.body}") 
      expect(page).to have_content("Answer #{answer.body}") 
    end

    scenario 'there is no content user looking for', js: true do
      visit questions_path
      within '.multisearch' do
        fill_in 'query', with: 'looking for smth'
        click_on 'Search'
      end
      expect(page).to have_content("No results") 
    end
  end

  describe 'Question scope search' do
    given!(:questions) {create_list(:question, 3, title: 'question search',  body: 'question body' )}

    scenario 'there is content user looking for', js: true do
      visit questions_path
      within '.question_search' do
        fill_in :query, with:  'question search'
        click_on 'Search'
      end
    
      expect(page).to have_content("#{questions[0].title} #{questions[0].body}") 
      expect(page).to have_content("#{questions[1].title} #{questions[1].body}") 
      expect(page).to have_content("#{questions[2].title} #{questions[2].body}") 
    end

    scenario 'there is no content user looking for', js: true do
      visit questions_path
      within '.question_search' do
        fill_in 'query', with: 'looking for smth'
        click_on 'Search'
      end
    
      expect(page).to have_content("No results") 
    end
  end
end
