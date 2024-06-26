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
      within '.navbar' do
        fill_in :query, with: 'global searching'
        click_on 'Search'
      end
    
      expect(page).to have_content("Question #{question.title} #{question.body}") 
      expect(page).to have_content("Answer #{answer.body}") 
    end

    scenario 'there is no content user looking for', js: true do
      visit questions_path
      within '.navbar' do
        fill_in 'query', with: 'looking for smth'
        click_on 'Search'
      end
      expect(page).to have_content("No results") 
    end
  end

  describe 'Scope search' do

  context 'Question scope search' do
    given!(:questions) {create_list(:question, 3, title: 'question search',  body: 'question body' )}

    scenario 'there is content user looking for', js: true do
      visit questions_path
      within '.scope_search' do
        select "Question", :from => "category"
        fill_in :query, with:  'question search'
        click_on 'Search'
      end
    
      expect(page).to have_content("#{questions[0].title} #{questions[0].body}") 
      expect(page).to have_content("#{questions[1].title} #{questions[1].body}") 
      expect(page).to have_content("#{questions[2].title} #{questions[2].body}") 
    end

    scenario 'there is no content user looking for', js: true do
      visit questions_path
      within '.scope_search' do
        select "Question", :from => "category"
        fill_in 'query', with: 'looking for smth'
        click_on 'Search'
      end
    
      expect(page).to have_content("No results") 
    end
  end

  context 'Answer scope search' do
    given!(:answers) {create_list(:answer, 3, body: 'answer search')}

    scenario 'there is content user looking for', js: true do
      visit questions_path
      within '.scope_search' do
        select "Answer", :from => "category"
        fill_in :query, with:  'answer search'
        click_on 'Search'
      end
    
      expect(page).to have_content("#{answers[0].body}") 
      expect(page).to have_content("#{answers[1].body}") 
      expect(page).to have_content("#{answers[2].body}") 
    end

    scenario 'there is no content user looking for', js: true do
      visit questions_path
      within '.scope_search' do
        select "Answer", :from => "category"
        fill_in 'query', with: 'looking for smth'
        click_on 'Search'
      end
    
      expect(page).to have_content("No results") 
    end
  end

  context 'Comment scope search' do
    given(:question) {create(:question)}
    given!(:comments) {create_list(:comment, 3, body: 'comment search', commentable: question)}

    scenario 'there is content user looking for', js: true do
      visit questions_path
      within '.scope_search' do
        select "Comment", :from => "category"
        fill_in :query, with:  'comment search'
        click_on 'Search'
      end
    
      expect(page).to have_content("#{comments[0].body}") 
      expect(page).to have_content("#{comments[1].body}") 
      expect(page).to have_content("#{comments[2].body}") 
    end

    scenario 'there is no content user looking for', js: true do
      visit questions_path
      within '.scope_search' do
        select "Comment", :from => "category"
        fill_in 'query', with: 'looking for smth'
        click_on 'Search'
      end
    
      expect(page).to have_content("No results") 
    end
  end

   describe 'User scope search' do
    given!(:user) {create(:user, email: 'user1@test.com')}
    given!(:question) {create(:question, author: user)}
    given!(:answer) {create(:answer, author: user)}
    given!(:comment) {create(:comment, commentable: question, user: user)}

    scenario 'there is content user looking for', js: true do
      visit questions_path
      within '.scope_search' do
        select "User", :from => "category"
        fill_in 'query', with: 'user1@test.com'
        click_on 'Search'
      end

      expect(page).to have_content("http://79.174.80.177/questions/#{question.id}") 
      expect(page).to have_content("http://79.174.80.177/questions/#{answer.question.id}") 
      expect(page).to have_content("http://79.174.80.177/questions/#{comment.commentable.id}") 
    end

    scenario 'there is no content user looking for', js: true do
      visit questions_path
      within '.scope_search' do
        select "User", :from => "category"
        fill_in 'query', with: 'looking for smth'
        click_on 'Search'
      end
    
      expect(page).to have_content("No results") 
    end
  end
end
end
