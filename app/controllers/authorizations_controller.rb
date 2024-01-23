class AuthorizationsController < ApplicationController
  
  def new
    @authorization = Authorization.new()
  end

  def create
    if find_user
      @authorization = @user.authorizations.new(authorization_params)
      @user.send_confirmation_instructions
      #sign_in_and_redirect @user, event: :authentication if @authorization.save! 
    else
      password = Devise.friendly_token[0, 20]
      user = User.new(email: authorization_params[:email], password: password)
      user.send_confirmation_instructions
      user.save
      user.create_authorization(authorization_params)
    end
  end

private

def find_user
  @user = User.where(email: params[:email]).first
end

def authorization_params
  params.require(:authorization).permit(:email, :uid, :provider)
end

end
