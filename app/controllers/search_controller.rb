class SearchController < ApplicationController

  skip_authorization_check

  def multisearch
    @result = PgSearch.multisearch(search_params[:query])
    if !@result.empty?
      render json: {links: link, results: @result }
    else
      render json: { text: "No results"}
    end
  end

  def question_search
    @result = Question.search_by_questions(search_params[:query])
     render_search_results("Question") 
  end

  def answer_search
    @result = Answer.search_by_answers(search_params[:query]) 
    render_search_results("Answer")
  end

  def comment_search
    @result = Comment.search_by_comments(search_params[:query])
     render_search_results("Comment") 
  end

  def user_search
    @result = User.search_by_users(search_params[:query])
     render_search_results("User") 
  end

  private

  def render_search_results(attr)
    if !@result.empty?
      render json: {links: scope_link(attr), results: @result }
    else
      render json: { text: "No results"}
    end
  end

  def link
    CreateLinkService.new.make_link_multisearch(@result)
  end

  def scope_link(resource)
    CreateLinkService.new.make_link_scope_search(resource, @result)
  end

  def search_params
    params.permit(:query)
  end
end
