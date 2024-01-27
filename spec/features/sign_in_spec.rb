require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign in
} do 

  given(:user) { create(:user) }
  given(:authorization) { create(:authorization, provider: 'github', uid: '123456', user: user)}

  background { visit new_user_session_path }
  
  scenario 'Registered user tries to sign in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end

  context 'User tries sign in with github ' do

    scenario 'user already has authorization' do
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({ 
        :provider => 'github', 
        :uid => '123456', 
        info: { email: user.email } })
   
      click_on 'Sign in with GitHub'

      expect(page).to have_content 'Successfully authenticated from Github account.'
    end

    scenario 'user has not authorization' do
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({ 
        :provider => 'github', 
        :uid => '123456', 
        info: { email: 'user@test.com' } })

      click_on 'Sign in with GitHub'
      expect(page).to have_content 'Successfully authenticated from Github account.'
    end
  end

  context 'user tries sign in with vkontakte' do
    scenario 'user already has authorization' do

      OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new({ 
        :provider =>  'vkontakte', 
        :uid =>  '123456'})
       user.create_authorization( OmniAuth.config.mock_auth[:vkontakte])
   
      click_on 'Sign in with Vkontakte'
      expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
    end

    scenario 'user has not authorization' do
      OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new({ 
        :provider => 'vkontakte', 
        :uid => '654321'})

      click_on 'Sign in with Vkontakte'
  
      fill_in 'authorization_email', with:'new_user@test'
      click_on 'SEND'

      open_email("new_user@test")
      current_email.click_link 'Confirm my account'
    
      expect(page).to have_content "Your email address has been successfully confirmed."
      click_on 'Sign in with Vkontakte'
      expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
    end
  end
end
  
