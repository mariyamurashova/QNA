class OauthCallbacksController < Devise::OmniauthCallbacksController

  before_action :find_user

  def github
    if @user&.persisted?
      sign_in_user(request.env['omniauth.auth'])
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def vkontakte
    auth = request.env['omniauth.auth']
    if @user && @user&.persisted? && @user.confirmed?
      sign_in_user(request.env['omniauth.auth'])
    else
      redirect_to new_authorization_path(provider: auth.provider, uid: auth.uid ), alert: 'Something went wrong'
    end
  end

  private

  def find_user
    @user = User.find_for_oauth(request.env['omniauth.auth'])
  end

  def sign_in_user(auth)
    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: "#{auth.provider.capitalize}") if is_navigational_format?
  end

end
