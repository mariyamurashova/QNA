require 'rails_helper'

feature 'User can sign up', %q{
  In order to have more abbilities
  I'd like to sign up
} do 

 given(:user) { create(:user) }

  background do
    visit  new_user_session_path 
    click_on 'Sign up'
    visit  new_user_registration_path
  end

   scenario 'Registrated User tries to sign up' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'
    
    expect(page).to have_content 'Email has already been taken'
  end

  scenario 'Password confirmation is empty' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Sign up'

    expect(page).to have_content "Password confirmation doesn't match Password"
  end

    scenario 'Unregistrated User tries to sign up with valid attributes' do
    fill_in 'Email', with: "user1@test.com"
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'
    
    expect(page).to have_content "Welcome! You have signed up successfully."
  end

end
