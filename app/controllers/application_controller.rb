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
      format.html do
        flash[:error] = exception.message
        redirect_to root_path
      end

      format.json { render json: flash, status: :forbidden }
  
      format.js { render js: flash[:error], status: :forbidden }
    end
  end

  check_authorization unless: :devise_controller?

end
