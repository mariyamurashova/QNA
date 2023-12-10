require 'rails_helper'

feature "The best answer's author gets an aword", %q{
  In order to view my awords
  As a best answer's author
   I'd like to be able to view my awords
} do

  given(:question_author) { create(:user) }
  given(:answer_author) { create(:user) }
  given!(:question) { create(:question, author: question_author) }
  given!(:aword) { create(:aword, question: question, user: answer_author) }
  given!(:answer) { create(:answer, question: question, author: answer_author, best: true) }

  describe 'Authenticated user' do 
    scenario 'user has awords' do
      sign_in answer_author
      visit questions_path
      click_on 'My Awords'
   
      expect(page).to have_content("Your awords:")
      expect(page).to have_content(aword.title)
      expect(page).to have_content(aword.question.title)
      expect(page).to have_css("img[src*='kolokol4848.png']")
    end
  
    scenario "user hasn't awords" do
      sign_in question_author
      visit questions_path
      click_on 'My Awords'
   
      expect(page).to have_content("You have no awords yet")
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do 
    visit questions_path
    
    expect(page).to have_link 'My Awords'
   end
end
