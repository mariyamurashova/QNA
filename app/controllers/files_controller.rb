class FilesController < ApplicationController
  before_action :authenticate_user!
  skip_authorization_check
  
  def destroy

    @file =ActiveStorage::Attachment.find_by(record_id: params[:id])
    @file.purge if current_user.author?(find_resource)
  end

  private

  def find_resource
   if @file.record_type == 'Answer'
     @resource = Answer.find_by(id: params[:id]) 
    else
     @resource = Question.find_by(id: params[:id]) 
    end
  end

end
