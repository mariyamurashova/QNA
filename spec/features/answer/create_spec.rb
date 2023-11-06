require 'rails_helper'

feature 'User can create the answer', %q{
  In order to help people to solve their
  problem
  As an authenticated user
  I want to be able to give an answer to the question
} do

given(:user) { create(:user) } 
given!(:question) { create(:question) }


describe 'Authenticated user' do

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'Authenticated user tries to publish an answer', js: true do
    fill_in 'Your answer', with: 'Answer,answer,answer'
    click_on('Add Answer')

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'Answer,answer,answer'
    end
  end

  scenario 'Authenticated user tries to publish an empty answer', js: true do
    click_on 'Add Answer'
      expect(page).to have_content "Body can't be blank"
  end
end
  scenario 'Unauthenticated user tries to publish an answer' do
    visit question_path(question)
    click_on 'Add Answer'
     
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
