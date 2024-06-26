require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a comunity
  As an authenticated user
  I'd like to be able to ask the question
} do

  given(:user) { create(:user) }

describe 'Authenticated user' do 
  background do
    sign_in(user)
    visit questions_path
    within '.navbar' do
      click_on 'Ask question'
    end
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
   end

  scenario 'asks a question' do 
      click_on 'Ask'
   

    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'text text text'
   end

   scenario 'asks a question with errors' do 
    fill_in 'Title', with: ''
    click_on 'Ask'

    expect(page).to have_content "Title can't be blank"
   end

  scenario 'asks a question with attached file' do
    attach_file 'question_files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
    click_on 'Ask'
    
    expect(page).to have_link 'rails_helper.rb'
    expect(page).to have_link 'spec_helper.rb'
  end 
end

context "mulitple sessions", js:true do
  scenario "question appears on another user's page" do
    
    Capybara.using_session('user') do
      sign_in(user)
      visit questions_path
    end
 
    Capybara.using_session('guest') do
      visit questions_path
    end
  
    Capybara.using_session('user') do
      within '.navbar' do
        click_on 'Ask question'
      end
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      
      within '.ask_question' do
        click_on 'Ask'
      end
      expect(page).to have_content 'Test question'
    end
     
    Capybara.using_session('guest') do
      sleep(5)
      within '.questions_list' do
        expect(page).to have_content 'Test question'
      end
    end
  end
end  

   scenario 'Unauthenticated user tries to ask a question' do 
    visit questions_path
    within '.navbar' do
      click_on 'Ask question'
    end
    
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    #expect(page).to_not have_link 'Ask_question'
   end
end
