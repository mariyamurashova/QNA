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

  private

  def link
    CreateLinkService.new.make_link(@result)
  end

  def search_params
    params.permit(:query)
  end


end
