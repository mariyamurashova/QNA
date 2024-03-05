require 'rails_helper'

feature "User can cancel subscription to question updates", %q{
  In order to cancel tracking changes
  As an authenticated user
  I'd like to be able to cancel the subscription
} do

  given!(:user) { create(:user) } 
  given!(:user1) { create(:user) } 
  given!(:question) { create(:question) }
  given!(:subscription) { create(:subscription, user: user, question: question) }
    
  scenario 'Authentecated user has subscription', js: true do
    sign_in(user)
    visit question_path(question)
    within '.question_unsubscribe' do
      click_on 'Unsubscribe'
    end  
    page.driver.browser.switch_to.alert.accept
    within '.notice' do
      expect(page).to have_content("Your subscription has been successfully deleted")
    end
  end

  scenario "Authentecated user hasn't subscription", js: true do
    sign_in(user1)
    visit question_path(question)
  
    expect(page).to_not have_link 'Unsubscribe'
  end
end

