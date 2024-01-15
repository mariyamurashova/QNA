class AnswersChannel < ApplicationCable::Channel
  
  def subscribed
     stream_from "answer_for_question#{params[:question_id]}"
  end
  
end

