require 'rails_helper'

feature 'User can create the answer', %q{
  In order to help people to solve their
  problem
  As an authenticated user
  I want to be able to give an answer to the question
} do

given(:user) { create(:user) } 
given!(:question) { create_list(:question, 3, author: user) }


describe 'Authenticated user' do

  background do
    sign_in(user)
    visit questions_path
    page.all(:css, 'a#questions_list').first.click
  end

  scenario 'Authenticated user tries to publish an answer' do
    fill_in 'body', with: 'Answer,answer,answer'
    click_on('Add Answer')

    expect(page).to have_content 'Your question successfully created'
    expect(page).to have_content 'Answer,answer,answer'
  end

  scenario 'Authenticated user tries to publish an empty answer' do
    click_on 'Add Answer'

    expect(page).to have_content "Body can't be blank"
  end
end

  scenario 'Unauthenticated user tries to publish an answer' do
    visit questions_path
    page.all(:css, 'a#questions_list').first.click
    click_on 'Add Answer'
     
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end

