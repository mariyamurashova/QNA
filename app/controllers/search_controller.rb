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
    if !@result.empty?
      render json: {links: scope_link("Question"), results: @result }
    else
      render json: { text: "No results"}
    end
  end

  def answer_search
    @result = Answer.search_by_answers(search_params[:query])
    if !@result.empty?
      render json: {links: scope_link("Answer"), results: @result }
    else
      render json: { text: "No results"}
    end
  end


  def comment_search
    @result = Comment.search_by_comments(search_params[:query])
    if !@result.empty?
      render json: {links: scope_link("Comment"), results: @result }
    else
      render json: { text: "No results"}
    end
  end

  private

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
