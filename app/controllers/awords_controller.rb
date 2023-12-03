class AwordsController < ApplicationController
   before_action :authenticate_user!

  def index
    @awords = current_user.awords
  end
end
