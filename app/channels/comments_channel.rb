class CommentsChannel < ApplicationCable::Channel
  
  def subscribed
    stream_from  "commentable_#{params[:question_id]}_comment"
  end
 
end
