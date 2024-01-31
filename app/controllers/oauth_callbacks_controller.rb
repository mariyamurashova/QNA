class OauthCallbacksController < Devise::OmniauthCallbacksController

 before_action :find_user

  def github
    signin_user('Github')
  end

  def vkontakte
    signin_user('Vkontakte')
  end

  private

  def signin_user(provider)
    if @user && @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "#{provider}") if is_navigational_format?
    else 
      create_authorization(request.env['omniauth.auth'])
    end
  end


  def create_authorization(auth)
    if auth && auth[:provider] && auth[:uid] && !@user
      redirect_to new_authorization_path(provider: auth[:provider], uid: auth[:uid]) 
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def find_user
    @user = User.find_for_oauth(request.env['omniauth.auth']) 
  end

end
