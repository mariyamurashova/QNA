class SearchController < ApplicationController

  skip_authorization_check

  def search
    @result = PgSearch.multisearch(search_params[:query])
    render_search_results(link) 
  end

  def scope_search
    @result =SearchService.new.searching(search_params[:category], search_params[:query])
    render_search_results(scope_link(search_params[:category])) 
  end

  private

  def render_search_results(links)
    if !@result.empty?
      render json: {links: links, results: @result }
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
    params.permit(:query, :category)
  end
end
