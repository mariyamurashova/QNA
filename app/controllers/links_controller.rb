class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @link =Link.find_by(linkable_id: params[:id])
    authorize! :destroy, @link
    @link.destroy  
  end
end
