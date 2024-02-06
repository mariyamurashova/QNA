# frozen_string_literal: true

class ApplicationController < ActionController::Base

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  def after_sign_in_path_for(resource_or_scope)
    root_path
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] =  exception.message
    redirect_to root_url
  end

  private

  #check_authorization  
end
