class AuthorizationsController < ApplicationController
  before_action :find_user, only: [:create]
  
  def new
    @authorization = Authorization.new()
  end

  def create
    if @user&.persisted?
      create_auth
      @user.create_authorization(@auth)
      sign_in_and_redirect @user, event: :authentication
      flash[:notice] = "Successfully authenticated from #{authorization_params[:provider]} account."
    else
      redirect_to new_authorization_path(provider: authorization_params[:provider], uid: authorization_params[:uid]) 
    end
  end

private

  def create_auth
    @auth = { }
    @auth[:provider] = authorization_params[:provider] 
    @auth[:uid] = authorization_params[:uid] 
  end

  def find_user
    if authorization_params && authorization_params[:email]
      @user = User.find_user(authorization_params[:email])
      @user = User.create_user(authorization_params[:email])  if !@user&.persisted?
    else
      flash[:notice] = "Please enter your email for authorization"
    end
  end

  def authorization_params
    params.require(:authorization).permit(:email, :uid, :provider)
  end

end
