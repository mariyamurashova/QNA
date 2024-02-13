class AwordsController < ApplicationController
  before_action :authenticate_user!
  authorize_resource

  def index
    @awords = current_user.awords
  end
end
