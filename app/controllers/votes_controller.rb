class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:create]

  def create
    @vote = @question.votes.new(user: current_user, value: params[:value])
    @rating = @question.rating
    respond_to do |format|
      if @vote.save
        format.json { render json: @vote }
      end
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

end
