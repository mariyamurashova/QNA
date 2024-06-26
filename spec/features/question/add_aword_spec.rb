require 'rails_helper'

feature 'User can create aword for the best answer', %q{
  In order to reward the author of the best answer
  As a question's author
  I'd like to be able to create an aword
} do

  given(:user) { create(:user) }
  given(:image) {"#{Rails.root}/spec/fixtures/kolokol4848.png"}

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

  scenario 'asks a question with Aword' do 

    fill_in 'Aword Title', with: 'Best answer'
    attach_file "question[aword_attributes][image]",image
    within '.ask_question' do
      click_on 'Ask'
    end
    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'text text text'
    expect(page).to have_content 'You can get an award for the best answer'
    expect(page).to have_css("img[src*='kolokol4848.png']")
  end

  scenario 'asks a question with errors in Aword' do 

    fill_in 'Aword Title', with: ''
    attach_file "question[aword_attributes][image]",image

    click_on 'Ask'

    expect(page).to have_content "Aword title can't be blank"
  end

end
end
