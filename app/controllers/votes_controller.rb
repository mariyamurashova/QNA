class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_vottable, only: [:create]


  def create
    @vote = @vottable.votes.new(user: current_user, value: params[:value])
    @rating = @vottable.rating
    respond_to do |format|
      if @vote.save
        format.json { render json: @vote }
      end
    end
  end

  private

   def vottable_name
    params[:vottable]
  end

  def set_vottable
    @vottable = vottable_name.classify.constantize.find(params[:vottable_id])
  end

end
