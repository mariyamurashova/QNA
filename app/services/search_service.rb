class SearchService
  def searching(category, query)
    case category
    when "Question"
      Question.search_by_questions(query)
    when "Answer"
      Answer.search_by_answers(query)
    when "Comment"
      Comment.search_by_comments(query) 
    when "User"
      User.search_by_users(query)
    end
  end
end
