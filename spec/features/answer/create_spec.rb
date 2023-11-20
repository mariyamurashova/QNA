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

  scenario 'tries to publish an answer', js: true do
    fill_in 'answer_body', with: 'Answer,answer,answer'
    click_on('Add Answer')

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'Answer,answer,answer'
    end
  end

  scenario ' tries to publish an empty answer', js: true do
    click_on 'Add Answer'
      expect(page).to have_content "Body can't be blank"
  end

  scenario 'answers to a question with attached file', js: true do
    fill_in 'answer_body', with: 'Answer,answer,answer'

    attach_file 'answer_files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
    click_on('Add Answer')
    
    within '.answers' do
    expect(page).to have_link 'rails_helper.rb'
    expect(page).to have_link 'spec_helper.rb'
  end
  end 
end
  scenario 'Unauthenticated user tries to publish an answer' do
    visit question_path(question)
    click_on 'Add Answer'
     
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
