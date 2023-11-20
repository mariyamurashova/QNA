class FilesController < ApplicationController
  before_action :authenticate_user!
 
  def destroy
    @file =ActiveStorage::Attachment.find_by(record_id: params[:id])
    @file.purge   
  end

end
