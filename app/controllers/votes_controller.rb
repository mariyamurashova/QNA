class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_vottable, only: [:create]


  def create
      @vote = @vottable.votes.new(user: current_user, value: params[:value])
      @rating = @vottable.rating
      respond_to do |format|
        if (!author_of? && @vote.save)
          format.json { render json: @vote } 
        else
          format.json do
            render json: @vottable.errors.full_messages, status: :unprocessable_entity
          end
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

   def author_of?
     if @vottable.author == current_user
      @vottable.errors.add(:'', "You couldn't vote for your #{vottable_name}")
    end
  end

end
