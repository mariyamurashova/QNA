class CreateLinkService
  def make_link(search_results)
    @links = [ ]
    search_results.each do |res|
     case res.searchable_type 
        when "Question" 
         question_link(res.searchable_id)
        when "Answer" 
          answer_link(res.searchable_id)
        when "Comment" 
          comment_link(res.searchable_id)
        
      end
      
    end
    return @links
  end

  def question_link(id)
     @links << "http://localhost:3000/questions/#{id}"
  end

  def answer_link(id)
    
     answer = Answer.where(id:id).first
      @links << "http://localhost:3000/questions/#{answer.question.id}"
  end

  def comment_link(id)
    comment = Comment.where(id: id).first
    if comment.commentable_type.include?('Answer')
      answer_link(comment.commentable_id)
    else
       question_link(comment.commentable_id)
    end
  end
end
