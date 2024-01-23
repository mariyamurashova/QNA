class AuthorizationsController < ApplicationController
  
  def new
    @authorization = Authorization.new()
  end

  def create
    if find_user
       @authorization = @user.authorizations.new(provider: params[:provider], uid: params[:uid])
      sign_in_and_redirect @user, event: :authentication if @authorization.save! 
    
      
      #set_flash_message(:notice, :success, kind: 'Vkontakte') if is_navigational_format?
    else
      password = Devise.friendly_token[0, 20]
      user = User.new
      user.create_user(params_email, password)
      user.create_authorization(auth)
    end
  end

private

def find_user
  @user = User.where(email: params[:email]).first
end

def params_email
  params.require(:authorization).permit(:email, :uid, :provider)
end

end
