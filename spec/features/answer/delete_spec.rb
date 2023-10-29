require 'rails_helper'

feature 'Author can delete his answer', %q{
In order to delete the answer 
As an answer's author
I'd like to be able to delete my answer
} do

  given(:user) { create(:user) }
  given(:author) { create (:user)}
  given(:question) { create(:question, author: user) }
  given!(:answers) { create_list(:answer, 3, question: question, author: author) }

  scenario "The question's author tries to delete it" do
    sign_in(author)
    visit question_path(question)
    page.all(:css,'a#delete_answer').first.click

    expect(page). to have_content 'Your answer was successfully deleted'
  end

  scenario "Others try to delete question" do
    sign_in(user)
    visit question_path(question)
    page.all(:css,'a#delete_answer').first.click

    expect(page). to have_content "You could'n delete this answer"
    
  end
end
