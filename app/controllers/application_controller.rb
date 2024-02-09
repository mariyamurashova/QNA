# frozen_string_literal: true

class ApplicationController < ActionController::Base

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  def after_sign_in_path_for(resource_or_scope)
    root_path
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    respond_to do |format|
      format.json do
        render json: flash, status: :forbidden
      end
  end
  end

  private

  #check_authorization unless: :devise_controller?
end
