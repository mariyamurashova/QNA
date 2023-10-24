require 'rails_helper'

feature 'User can signed out', %q{
  An authenticated user is able to log out
} do 

  given(:user) { create(:user) }
  
  scenario 'Authenticated user tries to log out' do
    sign_in(user)
    click_on 'Log out'
    save_and_open_page
    expect(page).to have_content 'Signed out successfully.'
  end
end
  
