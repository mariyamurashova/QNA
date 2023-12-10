class LinksController < ApplicationController
  before_action :authenticate_user!
 
  def destroy
    @link =Link.find_by(linkable_id: params[:id])
    if author?
      @link.destroy
    end   
  end

  private

  def author?
    current_user == @link.linkable.author
  end
end
