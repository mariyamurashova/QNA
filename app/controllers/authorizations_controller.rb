class AuthorizationsController < ApplicationController
  
  def new
    @authorization = Authorization.new()
  end

  def create

    if find_user
      @user.create_authorization(provider: authorization_params[:provider], uid: authorization_params[:uid]) 
    else
      password = Devise.friendly_token[0, 20]
      @user = User.create(email: authorization_params[:email], password: password, password_confirmation: password)
    
      @user.create_authorization(provider: authorization_params[:provider], uid: authorization_params[:uid])
    end
    
    sign_in_and_redirect @user, event: :authentication
    flash[:notice] = "Successfully authenticated from #{authorization_params[:provider]} account."
  end

private

def find_user
  @user = User.where(email: authorization_params[:email]).first
end

def authorization_params
  params.require(:authorization).permit(:email, :uid, :provider)
end

end
