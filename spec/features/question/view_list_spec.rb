require 'rails_helper'

feature 'User can view the list of questions', %q{
  In order to find the answer on existing questions
  As a user
  I'd like to be able to view the list of existing questions
} do
  given(:questions) { create_list(:question, 3) }
  scenario 'views the list of all questions' do
  
    visit questions_path
    questions.each do |question|
    expect(page).to have_content(question.title)
    end
  end
end
