require 'rails_helper'

feature "User can cancel subscription to question updates", %q{
  In order to cancel tracking changes
  As an authenticated user
  I'd like to be able to cancel the subscription
} do

  scenario 'Authenticated user cancels subscription' do
    sign_in(user)
    visit question_path(question)
    click_on 'Unsubscribe'
    expect(page).to have_content("your subscription has been cancelled successfully")
  end

end

