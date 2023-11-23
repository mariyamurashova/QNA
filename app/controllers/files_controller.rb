class FilesController < ApplicationController
  before_action :authenticate_user!
 
  def destroy
    @file =ActiveStorage::Attachment.find_by(record_id: params[:id])
    if author?
      @file.purge
    end   
  end

  private

  def find_resource
   if @file.record_type == 'Answer'
     @resource = Answer.find_by(id: params[:id]) 
    else
     @resource = Question.find_by(id: params[:id]) 
    end
  end

  def author?
    find_resource
    current_user == @resource.author
  end
end
