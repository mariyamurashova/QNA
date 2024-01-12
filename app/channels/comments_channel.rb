class CommentsChannel < ApplicationCable::Channel
  
  def follow(data)
    stream_from  "commentable_#{data["question_id"]}_comment"
  end
 
end
