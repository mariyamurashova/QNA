# frozen_string_literal: true

class ApplicationController < ActionController::Base

  def after_sign_out_path_for(resource_or_scope)
    questions_path
  end
  
end
