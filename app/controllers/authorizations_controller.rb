class AuthorizationsController < ApplicationController
  
  def new
    byebug
    @authorization = Authorization.new
  end

  def create
     find_user 
  end

private

def find_user
  @user = User.where(email: params[:email])
end

end
