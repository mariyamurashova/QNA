class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_vottable, only: [:create, :destroy]

  def create
      @vote = @vottable.votes.new(user: current_user, value: define_vote_value(params[:value]))
  
      respond_to do |format|
        if  !@vote.author_of_resource && @vote.save
          format.json { render json: @vottable.rating } 
        else
          format.json do
            render json: @vote.errors.full_messages, status: :forbidden
          end
        end 
      end
  end

  def destroy

    @vote =Vote.find_by(vottable_id: params[:vottable_id], vottable_type: params[:vottable].capitalize, user_id: current_user)

     respond_to do |format|
      if @vote
        @vote.destroy
        format.json {render json: @vottable.rating}
      else
        format.json do
          flash[:notice] = "You haven't voted yet"
          render json: flash, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def define_vote_value(value)
    return 1 if value == "like"
    return -1 if value == "dislike"
  end

   def vottable_name
    params[:vottable]
  end

  def set_vottable
    @vottable = vottable_name.classify.constantize.find(params[:vottable_id])
  end
end
