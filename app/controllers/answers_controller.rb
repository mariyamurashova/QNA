class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:create]
  before_action :find_answer, only: [:destroy]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user

    if @answer.save
      redirect_to @question, notice: 'Your question successfully created'
    end
  end

  def destroy
    if @answer.author == current_user
      @answer.destroy
      flash[:notice] = 'Your answer was successfully deleted'
    else
      flash[:notice] = "You could'n delete this answer"
    end
    
    redirect_to question_path(@answer.question)
  end


  private

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

end
