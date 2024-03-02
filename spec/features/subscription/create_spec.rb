require 'rails_helper'

feature "User can can subscribe to question's updates", %q{
  In order to track changes
  As an authenticated user
  I'd like to be able to subscribe to question
} do

given(:user) { create(:user) } 
given!(:question) { create(:question) }


 scenario 'Authenticated user subscribes to question' do
    sign_in(user)
    visit question_path(question)
    click_on 'Subscribe'
    expect(page).to have_content("the subscription has been successfully created")
  end

scenario 'Unauthenticated user tries to subscribe to question' do
  visit question_path(question)
  expect(page).to_not have_link 'Subscribe'
  end
end

